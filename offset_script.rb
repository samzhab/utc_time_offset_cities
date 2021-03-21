# Copyright (c) 2021 Samuel Y. Ayele
# frozen_string_literal: true

require 'utc_time_offset_cities'
file = File.read('available_locs_for_trend.json')
json_data = JSON.parse(file)
json_data.each do |dt|
  utc_offset = UtcTimeOffsetCities.get_utc_offset_for("#{dt['name']}, #{dt['country']}")
  dt['utc_offset'] = utc_offset
  puts "#{dt['name']}=>#{utc_offset}"
end
File.write('updated_json_data.json', JSON.dump(json_data))
grouped_data = json_data.group_by { |h| h['utc_offset'] }
File.write('updated_group_json_data.json', JSON.dump(grouped_data))
