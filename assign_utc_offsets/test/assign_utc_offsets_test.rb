# frozen_string_literal: true

# Copyright (c) 2021 Samuel Y. Ayele
require 'assign_utc_offsets'
require 'test/unit'
# class to assign utc_offsets for different places
class AssignUtcOffsetsTest < Test::Unit::TestCase
  PATH = 'available_locs_for_trend.json'

  def test_start_processing
    response = AssignUtcOffsets.start_processing("test/test_files/sample_test.json")
    assert_true response == 'completed'
    sleep 0.3
    assert_true File.exist?("#{Dir.pwd}/utc_offset_assigned_available_locations.json")
    assert_true File.exist?("#{Dir.pwd}/utc_offset_assigned_available_locations_grouped.json")
  rescue StandardError
    assert_true false
  end

  def test_assign_utc_offset
    sample_input = { 'name' => 'Tokyo',
                     'country' => 'Japan' }
    response = AssignUtcOffsets.assign_utc_offset(sample_input)
    assert_false response['utc_offset'].empty?
    assert_true response['name'] == sample_input['name']
    assert_true response['country'] == sample_input['country']
    assert_true response['utc_offset'] == 'UTC+9'
  end

  def test_write_to_file
    json_data = [{ 'name' => 'Tokyo', 'country' => 'Japan', 'utc_offset' => 'UTC+9' },
                 { 'name' => 'Toronto', 'country' => 'Canada', 'utc_offset' => 'UTC+9' }]
    AssignUtcOffsets.write_to_file(json_data)
    assert_true File.exist?("#{Dir.pwd}/utc_offset_assigned_available_locations.json")
    assert_true File.exist?("#{Dir.pwd}/utc_offset_assigned_available_locations_grouped.json")
  end
end
