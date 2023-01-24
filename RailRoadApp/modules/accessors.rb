module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*variables)
      store = Hash.new { |store, variable| store[variable] = [] }

      variables.each do |variable|
        define_method(variable) { instance_variable_get("@#{variable}") }

        define_method("#{variable}=") do |value|
          instance_variable_set("@#{variable}", value)
          store[variable] << value unless
          store[variable].include?(value)
        end

        define_method("#{variable}_history") do
          instance_variable_get("@#{variable}_history") ||
          instance_variable_set("@#{variable}_history", store[variable])
        end
      end
    end

    def strong_attr_accessor(variable, class_name)
      define_method(variable) { instance_variable_get("@#{variable}") }

      define_method("#{variable}=") do |value|
        raise TypeError, "Invalid type of value: must be #{class_name}" unless
        value.is_a? class_name

        instance_variable_set("@#{variable}", value)
      end
    end
  end
end

# class Test
#   include Accessors

#   attr_accessor_with_history :ass, :boobs
#   strong_attr_accessor :soul, String
# end
