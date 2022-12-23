require_relative 'modules/instance_counter'

class Station
  include InstanceCounter

  NAME_FORMAT = /^([a-z\d]+([[:space:]]){1}[a-z\d]+)$|^([a-z\d]+)$/i.freeze

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
    validate!
    @trains = []
    @trains_types = Hash.new(0)
    self.class.stations << self
    register_instance
  end

  def take_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def fill_trains_types
    trains_types.clear
    trains.each do |train|
      trains_types[train.type] += 1
    end
  end

  def each_train(&block)
    raise 'No block given.' unless block_given?

    trains.each { |train| block.call(train) }
  end

  private

  def validate!
    raise 'Invalid name format.' if name !~ NAME_FORMAT
  end
end
