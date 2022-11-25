require_relative "modules/instance_counter"

class Station
  include InstanceCounter

  NAME_FORMAT = /\A([a-z\d]+([[:space:]]){1}[a-z\d]+)\Z|\A([a-z\d]+)\Z/i

  @@stations = []

  def self.all
    @@stations.each do |station|
      station
    end
  end

  attr_reader :name, :trains, :train_types, :stations

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @train_types = Hash.new(0)
    @@stations << self
    register_instance
  end

  def take_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def train_types
    train_types.clear
    trains.each do |train|
      train_types[train.type] += 1
    end
  end

  private
  def validate!
    raise "InputError: Empty station name." if @name.empty?
    raise "InputError: Invalid name format." if @name !~ NAME_FORMAT
  end
end