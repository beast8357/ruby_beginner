class Station
  attr_accessor :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def take_train(train)
    self.trains << train
    "Train #{train.number} has been taken."
  end

  def send_train(train)
    self.trains.delete(train)
    "Train #{train.number} has been sent."
  end

  def show_trains
    self.trains.each do |train|
      puts "Number: #{train.number}; Type: #{train.type}; Wagons: #{train.cars}."
    end
  end

  def train_types
    types = Hash.new(0)
    self.trains.each do |train|
      types[train.type] += 1
    end
    types
  end
end