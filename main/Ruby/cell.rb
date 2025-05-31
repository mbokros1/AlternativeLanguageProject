# frozen_string_literal: true
require 'csv'

class Cell
  # Stored in a hash class attribute

  @@cell_data = {}

  def self.cell_data
    @@cell_data
  end

  # The column headers of cells.csv as attributes of the Cell class
  @oem
  @model
  @launch_announced
  @launch_status
  @body_dimensions
  @body_weight
  @body_sim
  @display_type
  @display_size
  @display_resolution
  @features_sensors
  @platform_os
  attr_accessor :oem,:model,:launch_announced,:launch_status,:body_dimensions,:body_weight,:body_sim,:display_type,
                :display_size,:display_resolution,:features_sensors,:platform_os

  # Constructor, using regex to match strings in valid formats; instances with other strings will have
  # nil for that value.
  # Fields that accept any string as valid, thus do not need regex: oem, model, body_dimensions, display_type,
  # and display_resolution.
  def initialize(oem, model, launch_announced, launch_status, body_dimensions,
                 body_weight, body_sim, display_type, display_size, display_resolution,
                 features_sensors, platform_os)
    @oem = oem.to_s
    @model = model.to_s
    @launch_announced = launch_announced.to_s[/\b\d{4}\b/]&.to_i # Captures first occurrence of 4-digit year, if any.
    @launch_status = launch_status.to_s[/(?:Discontinued|Cancelled|(Available.\. Released \d{4}))/]
    # Captures "Discontinued", "Cancelled", and "Available. Released <4-digit year>", ignores later characters.
    @body_dimensions = body_dimensions.to_s
    @body_weight = body_weight.to_s[/\d+(?:\.\d+)?(?=[ g(])/]&.to_f
    # Captures ints, floats, ignores following white space,'g', and '(' characters
    @body_sim = body_sim.to_s[/\A(?!Yes\z|No\z).+/]# Allows all strings except "Yes" and "No"
    @display_type = display_type.to_s
    @display_size = display_size.to_s[/\d+(?:\.\d+)?(?=[ i])/]&.to_f # Any integer or float followed by a space and the 'i' in inches
    @display_resolution = display_resolution.to_s
    @features_sensors = features_sensors.to_s[/(?=.*[A-Za-z]).+/]# Allows all strings that contain at least one letter
    @platform_os = platform_os.to_s[/(?=.*[A-Za-z]).+/]# Allows all strings that contain at least one letter
    
    @@cell_data[self] = @oem
    
  end

  def toString
    puts "OEM: #{@oem}, Model: #{@model}, Launch_Announced: #{@launch_announced}, Launch_Status: #{@launch_status},
body_dimensions: #{@body_dimensions}, body_weight: #{@body_weight}, body_sim: #{@body_sim}, display_type: #{@display_type},
display_size: #{@display_size}, display_resolution: #{@display_resolution}, features_sensors: #{@features_sensors},
platform_os: #{@platform_os}"
  end

  # Class methods to find the average of Launch_Announced, body_weight, and display_size:

  # Puts the keys (Cell objects, each called a phone here) into an array if @launch_announced is not nill (.compact),
  # then checks if the array is not empty and divides the sum of the keys in float form by the size of the array.
  def Cell.find_average_launch_announced
    keys = @@cell_data.keys.map{|phone| phone.launch_announced}.compact
    if keys.any?
      avg_launch = keys.sum.to_f / keys.size
      puts "Average year that launch was announced: #{avg_launch}"
    else
      puts "No launch announced!"
    end
  end

  # Puts the keys (Cell objects, each called a phone here) into an array if @body_weight is not nill (.compact),
  # then checks if the array is not empty and divides the sum of the keys in float form by the size of the array.
  def Cell.find_average_weight
    keys = @@cell_data.keys.map{|phone| phone.body_weight}.compact
    if keys.any?
      avg_weight = keys.sum.to_f / keys.size
      puts "Average weight: #{avg_weight}"
    else
      puts "No body weight found"
    end
  end

  def Cell.find_average_display_size
    keys = @@cell_data.keys.map{|phone| phone.display_size}.compact
    if keys.any?
      avg_display_size = keys.sum.to_f / keys.size
      puts "Average display size: #{avg_display_size}"
    else
      puts "No display size found"
    end
  end


  # What company (oem) has the highest average weight of the phone body?
  #def avg_weight_by_oem()
    # code goes here
  #end
  # Was there any phones that were announced in one year and released in another? What are they? Give me the oem and models.
  #def announced_vs_released()
    # code goes here
  #end
  # How many phones have only one feature sensor?
  #def count_of_features_sensors()
    # code goes here
  #end
  # What year had the most phones launched in any year later than 1999?
  #def count_of_launch_years()
    # code goes here
  #end
end

# File ingestion
CSV.foreach("cells.csv", headers: true) do |row|
  row = row.map { |val| val.nil? ? "" : val }
  row += [""] * (12 - row.size)
  Cell.new(*row[0...12])
end
Cell.find_average_launch_announced
Cell.find_average_weight
Cell.find_average_display_size
puts Cell.cell_data.size
