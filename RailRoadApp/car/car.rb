require_relative "../modules/manufacturer"

class Car
  include Manufacturer
  attr_reader :type
  
  TYPE_FORMAT = /^cargo$|^passenger$/

  def initialize(type = nil)
    @type = type
    validate!
  end

  private
  def validate!
    raise "TypeError: Type must be \'cargo\' or \'passenger\'." if
          @type.to_s !~ TYPE_FORMAT
  end
end