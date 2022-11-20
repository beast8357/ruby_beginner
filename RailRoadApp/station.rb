require_relative "modules/instance_counter"

class Station
  include InstanceCounter

  @@stations = []

  def self.all
    @@stations.each do |station|
      station
    end
  end

  attr_reader :name, :trains, :train_types, :stations

  def initialize(name)
    @name = name
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
end