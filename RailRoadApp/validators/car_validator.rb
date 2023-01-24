require_relative '../modules/validation'

class CarValidator
  include Validation

  TYPE_FORMAT = /^cargo$|^passenger$/

  validate :type, :type_format, TYPE_FORMAT
end

# t = CarValidator.new(type: :cargo)
# t.valid?
