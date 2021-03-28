# Copyright (c) 2021 Samuel Y. Ayele
# frozen_string_literal: true

require 'utc_time_offset_cities'
<<<<<<< HEAD
=======
require 'parallel'
>>>>>>> 5364204dd8fc755218829779c6da9fce77647c6c
# json updater
class AssignUtcOffsets
  class << self
    def start_processing(path)
      file = File.read(path)
      json_data = JSON.parse(file)
<<<<<<< HEAD
      json_data.each do |dt|
        utc_offset = UtcTimeOffsetCities.get_utc_offset_for("#{dt['name']}, #{dt['country']}")
        dt['utc_offset'] = utc_offset
        puts "#{dt['name']}, #{dt['country']}: #{utc_offset}"
      end
      write_to_file(json_data)
=======
      Parallel.each(json_data, in_threads: 2) { |location| assign_utc_offset(location) }
      write_to_file(json_data)
      'completed'
    end

    def assign_utc_offset(location)
      location['utc_offset'] = UtcTimeOffsetCities.get_utc_offset_for("#{location['name']},
                                                                      #{location['country']}")
      puts "#{location['name']}, #{location['country']}: #{location['utc_offset']}"
      location
>>>>>>> 5364204dd8fc755218829779c6da9fce77647c6c
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
