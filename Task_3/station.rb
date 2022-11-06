class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def take_train(train)
    @trains << train
    "Train #{train.number} has been taken."
  end

  def send_train(train)
    @trains.delete(train)
    "Train #{train.number} has been sent."
  end

  def show_trains
    @trains.each do |train|
      puts "Number: #{train.number}; Type: #{train.type}; Cars: #{train.cars}."
    end
  end

  def train_types
    types = Hash.new(0)
    @trains.each do |train|
      types[train.type] += 1
    end
    types
  end
end