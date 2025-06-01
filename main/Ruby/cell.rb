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
    if (@launch_status != "Discontinued") && (@launch_status != "Cancelled")
      str = @launch_status.to_s[/Available\. Released \d{4}/]
      if str.nil?
        @launch_status = nil
      else
        @launch_year = str[/\d{4}/].to_i # grabs the first four-digit year from launch status
      end
    elsif @launch_status == "Discontinued"
      if match = launch_announced.match(/Released .*?(\b\d{4}\b)/)
        @launch_year = match[1].to_i
      else
        @launch_year = @launch_announced.to_i
      end
    end
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

    @@cell_data[self.toString] = self
    
  end

  def toString
    str = "OEM: #{@oem}, Model: #{@model}, Launch_Announced: #{@launch_announced}, Launch_Status: #{@launch_status},
body_dimensions: #{@body_dimensions}, body_weight: #{@body_weight}, body_sim: #{@body_sim}, display_type: #{@display_type},
display_size: #{@display_size}, display_resolution: #{@display_resolution}, features_sensors: #{@features_sensors},
platform_os: #{@platform_os}"
    return str
  end

  # Class methods to find the average of Launch_Announced, body_weight, and display_size:

  # Puts the values (Cell objects, each called a phone here) into an array if @launch_announced is not nil (.compact),
  # then checks if the array is not empty and divides the sum of the keys in float form by the size of the array.
  def Cell.find_average_launch_announced
    values = @@cell_data.values.map{|phone| phone.launch_announced}.compact
    if values.any?
      avg_launch = values.sum.to_f / values.size
      avg_launch = avg_launch.to_i
      puts "Average year that launch was announced: #{avg_launch}"
      return avg_launch
    else
      puts "No launch announced!"
    end
  end

  # Puts the values (Cell objects, each called a phone here) into an array if @body_weight is not nil (.compact),
  # then checks if the array is not empty and divides the sum of the values in float form by the size of the array.
  def Cell.find_average_weight
    values = @@cell_data.values.map{|phone| phone.body_weight}.compact
    if values.any?
      avg_weight = values.sum.to_f / values.size
      puts "Average weight: #{avg_weight.round(2)}"
      return avg_weight
    else
      puts "No body weight found"
    end
  end

  # Puts the keys (Cell objects, each called a phone here) into an array if @display_size is not nil (.compact),
  # then checks if the array is not empty and divides the sum of the values in float form by the size of the array.
  def Cell.find_average_display_size
    values = @@cell_data.values.map{|phone| phone.display_size}.compact
    if values.any?
      avg_display_size = values.sum.to_f / values.size
      puts "Average display size: #{avg_display_size.round(2)}"
      return avg_display_size
    else
      puts "No display size found"
    end
  end


  # What company (oem) has the highest average weight of the phone body?
  def Cell.avg_weight_by_oem()
    max_avg = 0
    max_oem = ""
    oem_groups = Hash.new{|h,k| h[k] = []} # creates a new hash with OEMs as key and an array of weights as value
    @@cell_data.each_value do |phone| # loop through the cell_data by key (Cell object)
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
    return [max_oem,  max_avg]
  end

  # Were there any phones that were announced in one year and released in another? What are they?
  # Give me the oem and models.
  def Cell.announced_vs_released()
    dif = Array.new
    @@cell_data.each_value do |phone|
      next unless phone.launch_announced
      next unless phone.launch_year
      if phone.launch_announced.to_i != phone.launch_year.to_i
        dif << phone
      end
    end
    dif.each do |phone|
      puts "OEM: #{phone.oem}, Model: #{phone.model}, Year launch announced: #{phone.launch_announced},
 Year actually launched: #{phone.launch_year}"
    end
  end

  # How many phones have only one feature sensor?
  def Cell.count_of_features_sensors
    count_one = 0 # The count of phones with only one sensor
    count_multiple = 0 # The count of phones with multiple sensors, for debugging purposes only
    @@cell_data.each_value do |phone| # looping through cell_data
      next unless phone.features_sensors # filters out nil, but all phones have valid features_sensors in cells.csv
      str = phone.features_sensors.to_s.split(",") # array of features_sensors split by ","
      if str.length == 1
        count_one += 1
      elsif str.length > 1
        count_multiple += 1
      end
    end
    puts "#{count_one} phones have only one feature sensor."
    puts "#{count_multiple} phones have multiple feature sensors."
    return count_one
  end

  # What year had the most phones launched in any year later than 1999?
  def Cell.count_of_launch_years
    max_year = 0
    max_count = 0
    years = Hash.new{|h,k| h[k] = 0} # new hash with years as key and count as value, default being 0 instead of nil
    @@cell_data.each_value do |phone| # looping through cell_data
      next unless phone.launch_announced # skip phone if launch_year is nil
      years[phone.launch_announced] += 1 # increment value stored in the key by 1
    end
    years.sort.each do |year, count| # loop through the years hash
      # puts "#{year}: #{count} phones released" # output with key and value
      if (year > 1999) & (count.to_i > max_count.to_i)
        max_count = count
        max_year = year
      end
    end
    puts "The year that had the most launches since 1999 was #{max_year} with #{max_count} launches."
    return max_year
  end
  #end of class
end

# File ingestion
if __FILE__ == $0 # Done to prevent this code from running during unit tests; will only run if file is directly run.
  begin
    CSV.foreach("cells.csv", headers: true) do |row|
      vals = row.fields.map { |val| val.nil? ? "" : val.to_s }
      vals += [""] * (12 - vals.size)
      Cell.new(*vals[0...12])
    end
  rescue Errno::ENOENT
    puts "Cells.csv not found! Please make sure your file is in the correct location."
  end
  Cell.count_of_features_sensors
  Cell.count_of_launch_years
  Cell.avg_weight_by_oem
  puts "\nThese phones were announced and released in different years:"
  Cell.announced_vs_released
  #Cell.find_average_launch_announced
  #Cell.find_average_weight
  #Cell.find_average_display_size
  #puts Cell.cell_data.size
end