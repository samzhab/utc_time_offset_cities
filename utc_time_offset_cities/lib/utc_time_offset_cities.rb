# Copyright (c) 2021 Abin Abraham
# frozen_string_literal: true

# !/usr/bin/env ruby
require 'json'
require 'addressable'
require 'rest-client'
require 'nokogiri'
require 'tzinfo'
require 'geocoder'
# Class to get the UTC-OFFSET
class UtcTimeOffsetCities
  CRAWL_URL = 'https://time.is/time_zones'
  GEOCODE_API_URL = 'http://api.positionstack.com/v1/forward?access_key=a452a2b1127bfc593521b9f84c5770a3&query='
  TIMEZONE_API_URL = 'http://api.timezonedb.com/v2.1/get-time-zone?key=1Z8FB8L54XA0&format=json&by=position&'

  class << self
    def get_utc_offset_for(location)
      @location = location.to_s.strip
      return 'not found' if @location.empty?

      @city, @country = split_location
      return 'not found' if @city.empty? || @country.empty?

      utc_offset = utc_offset_by_crawling
      utc_offset = utc_offset_with_api if utc_offset.to_s == 'not found'
      utc_offset
    end

    def split_location
      splitted = @location.split(',').map { |lc| lc.to_s.strip.downcase }
      splitted << '' if splitted.count == 1
      splitted
    end

    def utc_offset_with_api
      timezone_data = timezone_data_with_geo_code
      return 'not found' unless TZInfo::Timezone.all_identifiers.include?(timezone_data['zoneName'].to_s)

      tz = TZInfo::Timezone.get(timezone_data['zoneName'].to_s)
      value_i = (tz.current_period.utc_total_offset.to_f / 3600.00)
      text = text_to_display(value_i)
      (text.empty? ? 'not found' : "UTC#{text}")
    rescue StandardError
      'not found'
    end

    def timezone_data_with_geo_code
      geocode_data = geocode_data_for_location
      sleep 0.2
      get_data_from_api('timezone',
                        "#{TIMEZONE_API_URL}lat=#{geocode_data['latitude']}&lng=#{geocode_data['longitude']}")
    end

    def geocode_data_for_location
      cordinate_hash = {}
      result = Geocoder.search(@location.to_s).first
      if !result.nil?
        cordinate_hash['latitude'] = result.coordinates.first
        cordinate_hash['longitude'] = result.coordinates.last
      else
        cordinate_hash = get_data_from_api('geocode',
                                           "#{GEOCODE_API_URL}#{@location}")
      end
      cordinate_hash
    end

    def text_to_display(value_i)
      value_s = value_i.to_s.gsub(/\.?0+$/, '').gsub('.5', ':30')
      value_s = '0' if value_i.zero?
      (value_i >= 0 ? "+#{value_s}" : value_s)
    end

    def get_data_from_api(type, url)
      response = get_request(url, {})
      data_parsed = JSON.parse(response.body)
      type == 'geocode' ? data_parsed['data'].first : data_parsed
    end

    def utc_offset_by_crawling
      begin
        response = get_request(CRAWL_URL.to_s, {})
      rescue RestClient::ExceptionWithResponse => e
        puts "Failed #{e}"
      end
      Nokogiri::HTML(response).css('.section').each do |section|
        utc_offset = section.css('h1').text.delete(' ')
        return utc_offset if utc_offset_found(section)
      end
      'not found'
    end

    def utc_offset_found(section)
      section.css('.country').text.to_s.downcase.include?(@country) && section.text.to_s.downcase.include?(@city)
    end

    def get_request(url, headers)
      RestClient::Request.execute(
        method: :get,
        url: Addressable::URI.parse(url).normalize.to_str,
        headers: headers, timeout: 50
      )
    end
  end
end
