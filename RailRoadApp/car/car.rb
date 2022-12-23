require_relative '../modules/manufacturer'

class Car
  include Manufacturer

  TYPE_FORMAT = /^cargo$|^passenger$/.freeze

  attr_reader :type, :volume, :occupied_volume

  def initialize(options = {})
    @type = options[:type]
    @volume = options[:volume].to_f || 0.0
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
