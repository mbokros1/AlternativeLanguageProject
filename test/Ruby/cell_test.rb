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
    assert_equal
  end
  def teardown
    # Do nothing
  end

end
