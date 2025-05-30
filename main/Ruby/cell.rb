# frozen_string_literal: true
require 'csv'

class Cell
  # Stored in a hash class attribute

  @@cell_data = Hash.new

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
  attr_accessor @oem,@model,@launch_announced,@launch_status,@body_dimensions,@body_sim,@display_type,@display_size,
                @display_resolution,@features_sensors,@platform_os

  def initialize(oem, model, launch_announced, launch_status, body_dimensions,
                 body_weight, body_sim, display_type, display_size, display_resolution,
                 features_sensors, platform_os)
    @oem = oem
    @model = model
    @launch_announced = launch_announced
    @launch_status = launch_status
    @body_dimensions = body_dimensions
    @body_weight = body_weight
    @body_sim = body_sim
    @display_type = display_type
    @display_size = display_size
    @display_resolution = display_resolution
    @features_sensors = features_sensors
    @platform_os = platform_os
    
    @@cell_data.store(self, @oem)
    
  end

  def toString()
    puts "OEM: #{@oem}, Model: #{@model}, Launch_Announced: #{@launch_announced}, Launch_Status: #{@launch_status},
body_dimensions: #{@body_dimensions}, body_weight: #{@body_weight}, body_sim: #{@body_sim}, display_type: #{@display_type},
display_size: #{display_size}, display_resolution: #{display_resolution}, features_sensors: #{@features_sensors},
platform_os: #{@platform_os}"
  end

  # Class methods to find the average of Launch_Announced, body_weight, and display_size:
  def Cell.find_average_launch
    avg_launch =
    puts "Average year that launch was announced: #{avg_launch}"
  end

  def Cell.find_average_weight
    avg_weight =
    puts "Average weight: #{avg_weight}"
  end

  def Cell.find_average_display_size
    avg_display_size =
    puts "Average display size: #{avg_display_size}"
  end


  # What company (oem) has the highest average weight of the phone body?
  def avg_weight_by_oem()
    # code goes here
  end
  # Was there any phones that were announced in one year and released in another? What are they? Give me the oem and models.
  def announced_vs_released()
    # code goes here
  end
  # How many phones have only one feature sensor?
  def count_of_features_sensors()
    # code goes here
  end
  # What year had the most phones launched in any year later than 1999?
  def count_of_launch_years()
    # code goes here
  end
end

# code goes here to create cell objects for each row of the csc and put them into a hash
