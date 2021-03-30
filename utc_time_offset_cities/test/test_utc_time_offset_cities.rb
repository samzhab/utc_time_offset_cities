# Copyright (c) 2021 Samuel Y. Ayele
# frozen_string_literal: true

require 'utc_time_offset_cities'
require 'test/unit'

class UtcTimeOffsetCitiesTest < Test::Unit::TestCase
  LOCATION = 'Tokyo, Japan'
  CITY = 'Tokyo'
  COUNTRY = 'Japan'
  UtcTimeOffsetCities.instance_variable_set(:@location, LOCATION)
  UtcTimeOffsetCities.instance_variable_set(:@city, CITY)
  UtcTimeOffsetCities.instance_variable_set(:@country, COUNTRY)

  def test_get_utc_offset_for
    utc_offset = UtcTimeOffsetCities.get_utc_offset_for(LOCATION)
    assert_false utc_offset.nil? || utc_offset.empty? || utc_offset.to_s == 'not found'
  end

  def test_split_location
    splitted_location = UtcTimeOffsetCities.split_location
    assert_true splitted_location.is_a?(Array)
    assert_false splitted_location.empty?
    assert_false splitted_location.count > 2
  end

  def test_utc_offset_with_api
    utc_offset = UtcTimeOffsetCities.utc_offset_with_api
    assert_false utc_offset.nil? || utc_offset.empty? || utc_offset.to_s == 'not found'
  end

  def test_timezone_data_with_geo_code
    timezone_data_with_geo_code = UtcTimeOffsetCities.timezone_data_with_geo_code
    assert_true timezone_data_with_geo_code['status'] == 'OK'
  end

  def test_geocode_data_for_location
    geocode_data_for_location = UtcTimeOffsetCities.geocode_data_for_location
    assert_false geocode_data_for_location.empty? ||
                 geocode_data_for_location['latitude'].to_s.empty?
    assert_true geocode_data_for_location.is_a?(Hash)
    assert_false geocode_data_for_location['longitude'].to_s.empty?
    assert_true geocode_data_for_location.keys.sort == %w[latitude longitude].sort
  end

  def test_text_to_display
    [-1, 1, 0, 5.5].each do |value|
      text = UtcTimeOffsetCities.text_to_display(value)
      text_to_display = (text.empty? ? 'not found' : "UTC#{text}")
      check_expectations(value, text_to_display)
    end
  end

  def check_expectations(value, text_to_display)
    case value
    when -1
      assert_true text_to_display == 'UTC-1'
    when 1
      assert_true text_to_display == 'UTC+1'
    when 0
      assert_true text_to_display == 'UTC+0'
    when 5.5
      assert_true text_to_display == 'UTC+5:30'
    end
  end

  def test_get_data_from_api
    geocode_data = UtcTimeOffsetCities.geocode_data_for_location
    url = "#{UtcTimeOffsetCities::TIMEZONE_API_URL}"\
    "lat=#{geocode_data['latitude']}&lng=#{geocode_data['longitude']}"
    data_from_api = UtcTimeOffsetCities.get_data_from_api('timezone',
                                                          url)
    assert_true data_from_api['status'] == 'OK'
    assert_false data_from_api['zoneName'].empty? || data_from_api['zoneName'].nil?
  end

  def test_utc_offset_by_crawling
    utc_offset = UtcTimeOffsetCities.utc_offset_by_crawling
    assert_false utc_offset.nil? || utc_offset.empty?
  end

  def test_utc_offset_found
    response = UtcTimeOffsetCities.get_request(UtcTimeOffsetCities::CRAWL_URL.to_s, {})
    assert_equal 200, response.code
    section = Nokogiri::HTML(response).css('.section').last
    response = UtcTimeOffsetCities.utc_offset_found(section)
    assert_true !!response == response
  end

  def test_get_request
    response = UtcTimeOffsetCities.get_request(UtcTimeOffsetCities::CRAWL_URL.to_s, {})
    assert_equal 200, response.code
  end
end
