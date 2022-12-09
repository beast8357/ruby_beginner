require_relative "../modules/manufacturer"

class Car
  include Manufacturer
  attr_reader :type, :volume, :occupied_volume
  
  TYPE_FORMAT = /^cargo$|^passenger$/

  def initialize(type = nil, volume = nil)
    @type = type
    @volume = volume.to_f
    @occupied_volume = 0.0
    validate!
  end

  def free_volume
    volume - occupied_volume
  end

  protected

  attr_writer :occupied_volume
  
  private

  def validate!
    raise "Type must be \'cargo\' or \'passenger\'." if type.to_s !~ TYPE_FORMAT
  end
end