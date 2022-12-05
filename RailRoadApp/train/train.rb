require_relative "../modules/manufacturer"
require_relative "../modules/instance_counter"

class Train
  include Manufacturer
  include InstanceCounter
  attr_reader :number, :type, :speed, :cars, :trains, 
              :route, :current_station

  NUMBER_FORMAT = /^[a-z\d]{3}-?[a-z\d]{2}$/i
  TYPE_FORMAT = /^cargo$|^passenger$/

  @@trains = {}

  def self.find(number)
    trains[number]
  end

  def initialize(number = nil, type = nil)
    @number = number
    @type = type
    @speed = 0
    @cars = []
    @@trains[number] = self
    validate!
    register_instance
  end

  def gain_speed(value)
    speed += value
  end

  def brake(value)
    speed -= value
    speed = 0 if speed < 0
  end

  def add_car(car)
    cars << car if speed == 0 && car.type == type
  end

  def unhook_car
    cars.pop if speed == 0 && cars.size > 0
  end

  def take_route(route)
    @route = route
    @current_station = route.stations.first
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
    @current_station.send_train(self)
    @current_station = station
    @current_station.take_train(self)
  end

  def current_station_index
    route.stations.index(current_station)
  end

  def each_car(&block)
    raise "No block given." unless block_given?
    cars.each.with_index(1) { |car, index| block.call(car, index) }
  end

  # protected

  # attr_writer :route, :current_station

  private

  def validate!
    raise "Invalid number format." if number !~ NUMBER_FORMAT
    raise "Type must be \'cargo\' or \'passenger\'." if type.to_s !~ TYPE_FORMAT
  end
end