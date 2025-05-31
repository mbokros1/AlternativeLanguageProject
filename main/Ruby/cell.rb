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
  @launch_year
  attr_accessor :oem,:model,:launch_announced,:launch_status,:body_dimensions,:body_weight,:body_sim,:display_type,
                :display_size,:display_resolution,:features_sensors,:platform_os, :launch_year

  # Constructor, using regex to match strings in valid formats; instances with other strings will have
  # nil for that value.
  # Fields that accept any string as valid, thus do not need regex: oem, model, body_dimensions, display_type,
  # and display_resolution.
  def initialize(oem, model, launch_announced, launch_status, body_dimensions,
                 body_weight, body_sim, display_type, display_size, display_resolution,
                 features_sensors, platform_os)
    @oem = oem
    @model = model
    @launch_announced = launch_announced[/\b\d{4}\b/]&.to_i # Captures first occurrence of 4-digit year, if any.
    @launch_status = launch_status[/(?:Discontinued|Cancelled|Available\. Released \d{4})/]
    # Captures "Discontinued", "Cancelled", and "Available. Released <4-digit year>", ignores later characters.
    @launch_year = launch_status[/\d{4}/]# grabs the first four-digit year from launch status
=begin
    if launch_year.nil?
      puts "year nil because status is #{launch_status}"
    else
      puts @launch_year
    end
=end
    @body_dimensions = body_dimensions
    @body_weight = body_weight[/\d+(?:\.\d+)?(?=[ g(])/]&.to_f
    # Captures ints, floats, ignores following white space,'g', and '(' characters
    @body_sim = body_sim[/\A(?!Yes\z|No\z).+/]# Allows all strings except "Yes" and "No"
    @display_type = display_type
    @display_size = display_size[/\d+(?:\.\d+)?(?=[ i])/]&.to_f # Any integer or float followed by a space and the 'i' in inches
    @display_resolution = display_resolution
    @features_sensors = features_sensors[/(?=.*[A-Za-z]).+/]# Allows all strings that contain at least one letter
    @platform_os = platform_os[/(?=.*[A-Za-z]).+/]# Allows all strings that contain at least one letter

    @@cell_data[self] = oem
    
  end

  def toString
    puts "OEM: #{@oem}, Model: #{@model}, Launch_Announced: #{@launch_announced}, Launch_Status: #{@launch_status},
body_dimensions: #{@body_dimensions}, body_weight: #{@body_weight}, body_sim: #{@body_sim}, display_type: #{@display_type},
display_size: #{@display_size}, display_resolution: #{@display_resolution}, features_sensors: #{@features_sensors},
platform_os: #{@platform_os}"
  end

  # Class methods to find the average of Launch_Announced, body_weight, and display_size:

  # Puts the keys (Cell objects, each called a phone here) into an array if @launch_announced is not nil (.compact),
  # then checks if the array is not empty and divides the sum of the keys in float form by the size of the array.
  def Cell.find_average_launch_announced
    keys = @@cell_data.keys.map{|phone| phone.launch_announced}.compact
    if keys.any?
      avg_launch = keys.sum.to_f / keys.size
      avg_launch = avg_launch.to_i
      puts "Average year that launch was announced: #{avg_launch}"
    else
      puts "No launch announced!"
    end
  end

  # Puts the keys (Cell objects, each called a phone here) into an array if @body_weight is not nil (.compact),
  # then checks if the array is not empty and divides the sum of the keys in float form by the size of the array.
  def Cell.find_average_weight
    keys = @@cell_data.keys.map{|phone| phone.body_weight}.compact
    if keys.any?
      avg_weight = keys.sum.to_f / keys.size
      puts "Average weight: #{avg_weight.round(2)}"
    else
      puts "No body weight found"
    end
  end

  # Puts the keys (Cell objects, each called a phone here) into an array if @display_size is not nil (.compact),
  # then checks if the array is not empty and divides the sum of the keys in float form by the size of the array.
  def Cell.find_average_display_size
    keys = @@cell_data.keys.map{|phone| phone.display_size}.compact
    if keys.any?
      avg_display_size = keys.sum.to_f / keys.size
      puts "Average display size: #{avg_display_size.round(2)}"
    else
      puts "No display size found"
    end
  end


  # What company (oem) has the highest average weight of the phone body?
  def Cell.avg_weight_by_oem()
    max_avg = 0
    max_oem = ""
    oem_groups = Hash.new{|h,k| h[k] = []} # creates a new hash with OEMs as key and an array of weights as value
    @@cell_data.each_key do |phone| # loop through the cell_data by key (Cell object)
      next unless phone.body_weight # skips each phone if body_weight is nil
      oem_groups[phone.oem] << phone.body_weight # enters body_weight into the array for the OEM
    end
    # puts "Average weight for each oem:"
    oem_groups.each do |oem, weight_array| # loops through each OEM
      average = weight_array.sum.to_f / weight_array.size # divides the sum of weights by the number of weights
      if average > max_avg
        max_avg = average
        max_oem = oem
      end
      # puts "#{oem}: #{average.round(2)} g"
    end
    puts "The company with the highest average weight is #{max_oem} at #{max_avg} grams."
  end

  # Was there any phones that were announced in one year and released in another? What are they?
  # Give me the oem and models.
  def Cell.announced_vs_released()
    # code goes here
  end

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
  vals = row.fields.map { |val| val.nil? ? "" : val.to_s }
  vals += [""] * (12 - vals.size)
  Cell.new(*vals[0...12])
end
#Cell.find_average_launch_announced
#Cell.find_average_weight
#Cell.find_average_display_size
Cell.avg_weight_by_oem
# puts Cell.cell_data.size
