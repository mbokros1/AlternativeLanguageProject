# frozen_string_literal: true

class Cell
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

  def initialize(oem, model, launch_announced, launch_status, body_dimensions, body_weight,
                 body_sim, display_type, display_size, display_resolution, features_sensors,
                 platform_os)
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
  end
end
