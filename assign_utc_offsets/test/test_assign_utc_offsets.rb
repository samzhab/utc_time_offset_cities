# frozen_string_literal: true

require 'assign_utc_offsets'
require 'test/unit'

class AssignUtcOffsetsTest < Test::Unit::TestCase
  PATH = 'available_locs_for_trend.json'

  def test_start_processing
    response = AssignUtcOffsets.start_processing(PATH)
    assert_true response == 'completed'
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

  def test_output_file_exist
    assert_true File.exist?("#{Dir.pwd}/utc_offset_assigned_available_locations.json")
    assert_true File.exist?("#{Dir.pwd}/utc_offset_assigned_available_locations_grouped.json")
  end
end
