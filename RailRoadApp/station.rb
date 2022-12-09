require_relative "modules/instance_counter"

class Station
  include InstanceCounter
  attr_reader :name, :trains, :train_types, :stations

  NAME_FORMAT = /\A([a-z\d]+([[:space:]]){1}[a-z\d]+)\Z|\A([a-z\d]+)\Z/i

  @@stations = []

  def self.all
    stations.each do |station|
      station
    end
  end

  def initialize(name = nil)
    @name = name
    @trains = []
    @train_types = Hash.new(0)
    @@stations << self
    validate!
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

  def each_train(&block)
    raise "No block given." unless block_given?
    trains.each.with_index(1) { |train| block.call(train) }
  end

  private
  
  def validate!
    raise "Invalid name format." if name !~ NAME_FORMAT
  end
end