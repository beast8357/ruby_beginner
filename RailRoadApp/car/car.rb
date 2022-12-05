require_relative "../modules/manufacturer"

class Car
  include Manufacturer
  include InstanceCounter
  attr_reader :type, :volume, :occupied_volume
  
  TYPE_FORMAT = /^cargo$|^passenger$/

  def initialize(type = nil, volume = nil)
    @type = type
    @volume = volume
    @occupied_volume = 0
    validate!
    register_instance
  end

  def occupy(value)
    raise "Your value is too big!" if value > free_volume
    @occupied_volume += value
  end

  def free_volume
    volume - occupied_volume
  end

  private
  
  def validate!
    raise "Type must be \'cargo\' or \'passenger\'." if type.to_s !~ TYPE_FORMAT
  end
end