require_relative 'modules/instance_counter'
require_relative 'validators/station_validator'

class Station
  include InstanceCounter

  @stations = []

  class << self
    attr_accessor :stations
  end

  attr_reader :name, :trains, :trains_types

  def self.all
    self.class.stations.each { |station| station }
  end

  def initialize(name)
    @name = name
    @trains = []
    @trains_types = Hash.new(0)
    self.class.stations << self
    register_instance if StationValidator.new(name: name).valid?
  end

  def take_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def fill_trains_types
    trains_types.clear
    trains.each { |train| trains_types[train.type] += 1 }
  end

  def each_train(&block)
    raise 'No block given.' unless block_given?

    trains.each { |train| block.call(train) }
  end
end
