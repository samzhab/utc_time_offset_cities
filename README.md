## UTC offset for Major Cities - Ruby

![temporary logo](https://bt-strike.s3-us-west-2.amazonaws.com/images/ruby.gif 'bt-strike temporary logo')

A simple ruby script that assigns utc offset values for most major cities in the world.

Prerequisites:

- rvm (rvm.io)
- ruby interpreter (2.7.0)
- required gems (see Gemfile)
- linux terminal

Tasks:

- Take input list of cities and produce a json with utc time offsets assigned to them<!-- * current state 1 -->
<!-- * current state 2  -->

Modules and APIs involved in this project:

<!-- * to fill later  -->

Features to add [coming soon...]

- feature 1

Setup usage with rvm and process event series:

- get latest ruby interpreter
  `$ rvm install ruby`
- create a gemset
  `$ rvm gemset create <gemset>`
  eg. `$ rvm gemset create person_doesnot_exist`
- use created gemset
  `$ rvm <ruby version>@<gemset>`
- install bundler gem
  `$ gem install bundler`
- install necessary gems
  `$ bundle`
- create folder 'persons' for articles saved as pdf
  `$ mkdir persons`
- make script executable
  `$ chmod +x <script_name.rb>`
- run script
  `$ ./<script_name.rb>`

This repository has two gems

- utc_time_offset_cities: For parsing the UTC offsets for different locations
- assign_utc_offsets: For assigning UTC offsets for locations in the provided JSON

Setup & usage

- Clone the repository
  `$ git clone https://github.com/samzhab/utc_time_offset_cities.git`
- Move into the cloned directory
  `$ cd utc_time_offset_cities`
- Install both gems
  `$ cd utc_time_offset_cities`
  `$ gem install utc_time_offset_cities`
  `$ cd ..`
  `$ cd assign_utc_offsets`
  `$ gem install assign_utc_offsets`
- then open irb
  `$ irb`

- To use utc_time_offset_cities
- within irb run
  require 'utc_time_offset_cities'
  UtcTimeOffsetCities.get_utc_offset_for(city, country)

- To use assign_utc_offsets
- This should be within the folder assign_utc_offsets
- within irb run
  require 'assign_utc_offsets'
  AssignUtcOffsets.start_processing('available_locs_for_trend.json')

Further Development [coming soon...]

- Task 1 -
- Task 1-1 -

Tests
To test gems
move into the gem's root folder
`$ rake test`

Shield: [![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

This work is licensed under a
[Creative Commons Attribution-NonCommercialShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>
