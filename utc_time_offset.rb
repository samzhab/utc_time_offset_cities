#!/usr/bin/env ruby
require "json"
require "addressable"
require "rest-client"
require "byebug"
require "nokogiri"
require "csv"
require "down"
# require "webmock"
require "fileutils"

class UtcOffset
  BASE_URL = 'https://time.is/'
  PATH = 'available_locs_for_trend.json'
  GEOCODE_BASE_URL = 'http://api.positionstack.com/v1/forward?access_key=a452a2b1127bfc593521b9f84c5770a3&query='
  TIMEZONE_BASE_URL = 'http://api.timezonedb.com/v2.1/get-time-zone?key=1Z8FB8L54XA0&format=json&by=position&'

  def start
    begin
      response = get_request("#{BASE_URL}time_zones", {})
    rescue RestClient::ExceptionWithResponse => e
      puts "Failed #{e}"
    end
    json_data = read_from_json('available_locs_for_trend.json')
    nokogiri_parser = Nokogiri::HTML(response)
    parsed_data = parse_utc_offset(nokogiri_parser, json_data)
    new_json_data = process_utc_offset(parsed_data, json_data)
    write_json_to_file(new_json_data)
  end
  
  private
  
  def write_json_to_file(new_json_data)
    new_json_data_grouped = new_json_data.group_by{ |h| h['utc_offset'] }
    File.write("new_json_data_grouped.json", JSON.dump(new_json_data_grouped))
  end

  def read_from_json(path)
    file = File.read('available_locs_for_trend.json')
    JSON.parse(file)
  end

  def parse_utc_offset(nokogiri_parser, json_data)
    parsed_info = []
    nokogiri_parser.css('.section').each do |section|
      utc_offset = section.css('h1').text.delete(' ')
      section.css('.country').each do |country_sec|
        country_sec.parent.children.css('li').css('a').each do |twn|
          parsed_info << {'name'=>twn.text.to_s.downcase, 'utc_offset'=>utc_offset, 'country'=>country_sec.text.to_s.downcase}
        end
      end
    end
    parsed_info
  end

  def process_utc_offset(parsed_data, json_data)
    json_data.each do |dt|
      matching_data = (parsed_data.select{|pd| dt['name'].to_s.downcase == pd['name'] && dt['country'].to_s.downcase == pd['country']}.first||{'utc_offset'=>'not found'})
      dt['utc_offset'] = matching_data['utc_offset']
    end
    json_data
  end

  def crawled_data(nokogiri_parser)
    crawled_data = []
    nokogiri_parser.css('.country').each do |country_element|
      country_name = country_element.text
      country_element.parent.children.css('a').each do |a|
        crawled_data << {'name' => a.text, 'country' => country_name, 'url' => a['href']}
      end
    end
    crawled_data
  end

  def process_data(json_data, crawled_data)
    json_data.each do |js|
      utc_offset = fetch_by_crawl(js, crawled_data)
      if utc_offset == 'not found'
        puts 'API....'
        # utc_offset = fetch_with_api(js)
      end
      js['utc_offset'] = utc_offset
      p "utc_offset=>#{utc_offset}"
    end
    json_data
  end

  def fetch_by_crawl(js, crawled_data)
    matching_data = crawled_data.select {|cd| cd['name'].to_s.downcase == js['name'].to_s.downcase && cd['country'].to_s.downcase == js['country'].to_s.downcase && js['placeType']['name'] == 'Town' }
    matching_data = crawled_data.select {|cd| cd['name'].to_s.downcase == js['country'].to_s.downcase && cd['country'].to_s.downcase == js['country'].to_s.downcase && js['placeType']['name'] == 'Country'} if matching_data.empty?
    utc_offset = fetch_utc_offset(matching_data.first)
    utc_offset
  end

  def fetch_utc_offset(url_hash)
    return 'not found' if url_hash.nil?
    begin
      response = get_request("#{BASE_URL}#{url_hash['url']}", {})
    rescue RestClient::ExceptionWithResponse => e
      puts "Failed #{e}"
    end
    Nokogiri::HTML(response).css('#clock').each do |clock|
      return clock.text
    end
  end

  def fetch_with_api(js)
    return 'not found' if js['name'].to_s.empty? || js['country'].to_s.empty?
    geocode_response = get_request("#{GEOCODE_BASE_URL}#{js['name'].to_s}, #{js['country'].to_s}", {})
    sleep 0.2
    return 'not found' if geocode_response.code != 200
    geocode_data = JSON.parse(geocode_response.body)['data'].first
    return 'not found' if geocode_data.nil? || !geocode_data.is_a?(Hash)
    timezone_response = get_request("#{TIMEZONE_BASE_URL}lat=#{geocode_data['latitude'].to_s}&lng=#{geocode_data['longitude'].to_s}", {})
    sleep 0.2
    return 'not found' if timezone_response.code != 200
    response_data_for_time = JSON.parse(timezone_response.body)['formatted'].to_s.split(' ').last
  end

  def get_request(url, headers)
    response = RestClient::Request.execute(
      method: :get,
      url: Addressable::URI.parse(url).normalize.to_str,
      headers: headers, timeout: 50
    )
    response
  end
end

utc_offset = UtcOffset.new
utc_offset.start