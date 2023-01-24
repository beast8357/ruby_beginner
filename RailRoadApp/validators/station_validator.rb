require_relative '../modules/validation'

class StationValidator
  include Validation

  NAME_FORMAT = /^([a-z\d]+([[:space:]]){1}[a-z\d]+)$|^([a-z\d]+)$/i

  validate :name, :presence
  validate :name, :name_format, NAME_FORMAT
  validate :name, :type, String
end

# t = StationValidator.new(name: "s1")
# t.valid?
