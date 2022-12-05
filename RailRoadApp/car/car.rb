require_relative "../modules/manufacturer"

class Car
  include Manufacturer
  include InstanceCounter
  attr_reader :type, :seats, :taken_seats, :volume, :occupied_volume
  
  TYPE_FORMAT = /^cargo$|^passenger$/

  def initialize(type = nil, seats = 0, volume = 0.0)
    @type = type
    @seats = seats.to_i
    @taken_seats = 0
    @volume = volume.to_f
    @occupied_volume = 0.0
    validate!
    register_instance
  end

  def free_seats
    seats - taken_seats
  end

  def free_volume
    volume - occupied_volume
  end

  protected

  attr_writer :taken_seats, :occupied_volume
  
  private

  def validate!
    raise "Type must be \'cargo\' or \'passenger\'." if type.to_s !~ TYPE_FORMAT
  end
end