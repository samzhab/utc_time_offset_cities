# Copyright (c) 2021 Samuel Y. Ayele
# frozen_string_literal: true

require 'utc_time_offset_cities'
require 'parallel'
# json updater
class AssignUtcOffsets
  class << self
    def start_processing(path)
      file = File.read(path)
      json_data = JSON.parse(file)
      Parallel.each(json_data, in_threads: 2) { |location| assign_utc_offset(location) }
      write_to_file(json_data)
    end

    def assign_utc_offset(location)
      location['utc_offset'] = UtcTimeOffsetCities.get_utc_offset_for("#{location['name']},
                                                                      #{location['country']}")
      puts "#{location['name']}, #{location['country']}: #{location['utc_offset']}"
    end

    def write_to_file(json_data)
      File.write("#{Dir.pwd}/utc_offset_assigned_available_locations.json",
                 JSON.dump(json_data))
      grouped_data = json_data.group_by { |h| h['utc_offset'] }
      File.write("#{Dir.pwd}/utc_offset_assigned_available_locations_grouped.json",
                 JSON.dump(grouped_data))
    end
  end
end

AssignUtcOffsets.start_processing('available_locs_for_trend.json')
