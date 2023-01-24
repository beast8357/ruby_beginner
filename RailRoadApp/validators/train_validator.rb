require_relative '../modules/validation'

class TrainValidator
  include Validation

  NUMBER_FORMAT = /^[a-z\d]{3}-?[a-z\d]{2}$/i
  TYPE_FORMAT = /^cargo$|^passenger$/

  validate :number, :presence
  validate :number, :number_format, NUMBER_FORMAT
  validate :type, :type_format, TYPE_FORMAT
end

# t = TrainValidator.new(number: "qwe12", type: :cargo)
