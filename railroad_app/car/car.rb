require_relative '../modules/manufacturer'
require_relative '../validators/car_validator'

class Car
  include Manufacturer

  attr_reader :type, :volume, :occupied_volume

  def initialize(options = {})
    @type = options[:type]
    @volume = options[:volume].to_f || 0.0
    @occupied_volume = 0.0
    CarValidator.new(type: type).valid?
  end

  def free_volume
    volume - occupied_volume
  end

  protected

  attr_writer :occupied_volume
end
