class BadValidationError < StandardError; end

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def params_collections
      @params_collections ||= []
    end

    def validate(attr_name, validation_type, *options)
      params_collections << {
        attr_name: attr_name,
        validation_type: validation_type,
        options: options
      }
    end
  end

  module InstanceMethods
    def initialize(attributes)
      attributes.each do |attr_name, value|
        instance_variable_set("@#{attr_name}", value)
      end
    end

    def validate!
      self.class.params_collections.each do |collection|
        attr_value = instance_variable_get("@#{collection[:attr_name]}")
        validation_type = collection[:validation_type]
        option = collection[:options].first
        send("validate_#{validation_type}", attr_value, option)
      end
    end

    def valid?
      validate!
      true
    rescue BadValidationError => error
      puts error.message
      false
    end

    protected

    def validate_presence(attribute, _)
      raise BadValidationError, "Attribute is missing" if attribute.nil? || attribute == ""
    end

    def validate_type(type, class_name)
      raise BadValidationError, "Invalid type" unless type.is_a? class_name
    end

    def validate_name_format(name, name_format)
      raise BadValidationError, "Invalid name format" unless name =~ name_format
    end

    def validate_number_format(number, number_format)
      raise BadValidationError, "Invalid number format" unless number =~ number_format
    end

    def validate_type_format(type, type_format)
      raise BadValidationError, "Invalid type format" unless type =~ type_format
    end
  end
end
