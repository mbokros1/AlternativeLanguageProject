# frozen_string_literal: true

require 'minitest/autorun'
require 'csv'
require_relative '../../main/Ruby/cell'

class CellTest < Minitest::Test
  def setup
    @phones = []
    begin
      CSV.foreach("test.csv", headers: true) do |row|
        vals = row.fields.map { |val| val.nil? ? "" : val.to_s }
        vals += [""] * (12 - vals.size)
        @phones << Cell.new(*vals[0...12])
      end
    rescue Errno::ENOENT
      puts "Cells.csv not found! Please make sure your file is in the correct location."
    end
  end

  # Testing cell methods:
  def test_toString
    str = "OEM: Test Company, Model: Examplephone 3a, Launch_Announced: 2025, Launch_Status: Available. Released 2025,
body_dimensions: 151.3 x 70.1 x 8.2 mm (5.96 x 2.76 x 0.32 in), body_weight: 147.0, body_sim: Nano-SIM, display_type: OLED capacitive touchscreen, 16M colors,
display_size: 5.6, display_resolution: 1080 x 2220 pixels, 18.5:9 ratio (~441 ppi density), features_sensors: Fingerprint (rear-mounted), accelerometer, gyro, proximity, compass, barometer,
platform_os: Android 15"
    assert_equal str, @phones[0].toString
  end

  def test_avg_launch_announced
    ans = (2025.0 + 1999.0)/2.0
    ans = ans.to_i
    assert_equal ans, @phones[0].class.find_average_launch_announced
  end

  # Test if cells.csv is not empty
  def test_cellsCSV
    data_found = false
    CSV.foreach("test.csv", headers: true) do |row|
      data_found = true
      break
    end
    assert data_found
  end

  # Test each columns final transformation
  def test_columns
    assert_equal String, @phones[0].oem.class
    assert_equal String, @phones[0].model.class
    assert_equal Integer, @phones[0].launch_announced.class
    assert_equal String, @phones[0].launch_status.class
    assert_equal Integer, @phones[0].launch_year.class
    assert_equal String, @phones[0].body_dimensions.class
    assert_equal Float, @phones[0].body_weight.class
    assert_equal String, @phones[0].body_sim.class
    assert_equal String, @phones[0].display_type.class
    assert_equal Float, @phones[0].display_size.class
    assert_equal String, @phones[0].display_resolution.class
    assert_equal String, @phones[0].features_sensors.class
    assert_equal String, @phones[0].platform_os.class
  end

  # Ensure missing data is an empty String (was originally nil but that caused errors elsewhere so had to
  # implement as an empty String)
  def test_whether_empty
    assert_equal "", @phones[1].body_dimensions
  end
  def teardown
    # Do nothing
  end

end
