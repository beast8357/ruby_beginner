require_relative '../modules/manufacturer'
require_relative '../modules/instance_counter'
require_relative '../validators/train_validator'

class Train
  include Manufacturer
  include InstanceCounter

  @@trains = {}

  attr_reader :number, :type, :speed, :cars, :route, :current_station

  def self.find(number)
    @@trains[number]
  end

  def initialize(options = {})
    @number = options[:number]
    @type = options[:type]
    @speed = 0
    @cars = []
    @@trains[number] = self
    register_instance if TrainValidator.new(number: number, type: type).valid?
  end

  def gain_speed(value)
    speed + value
  end

  def brake(value)
    speed =
      if (speed - value).negative?
        0
      else
        speed - value
      end
  end

  def add_car(car)
    cars << car if speed.zero? && car.type == type
  end

  def unhook_car
    cars.pop if speed.zero? && !cars.size.empty
  end

  def take_route(route_to_take)
    self.route = route_to_take
    self.current_station = route.stations.first
    current_station.take_train(self)
  end

  def to_next_station
    change_current_station(next_station)
  end

  def to_previous_station
    change_current_station(previous_station)
  end

  def next_station
    condition = route.stations[current_station_index] != route.stations.last
    route.stations[current_station_index + 1] if condition == true
  end

  def previous_station
    condition = route.stations[current_station_index] != route.stations.first
    route.stations[current_station_index - 1] if condition == true
  end

  def change_current_station(station)
    current_station.send_train(self)
    self.current_station = station
    current_station.take_train(self)
  end

  def current_station_index
    route.stations.index(current_station)
  end

  def each_car(&block)
    raise 'No block given.' unless block_given?

    cars.each.with_index(1) { |car, index| block.call(car, index) }
  end

  protected

  attr_writer :route, :current_station
end
