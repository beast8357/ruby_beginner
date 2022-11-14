class Train
  attr_reader :number, :type, :cars, :speed, :current_station

  def initialize(number)
    @number = number
    @cars = []
    @speed = 0
  end

  def gain_speed(value)
    speed += value
  end

  def brake(value)
    speed -= value
    speed = 0 if speed < 0
  end

  def add_car(car)
    cars.push(car) if speed == 0
  end

  def unhook_car(car)
    if speed == 0
      cars.delete(car) if cars.size > 0 
    end
  end

  def take_route(route)
    route = route
    current_station = route.stations.first
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
    route.stations[current_station_index + 1] if condition
  end

  def previous_station
    condition = route.stations[current_station_index] != route.stations.first
    route.stations[current_station_index - 1] if condition
  end

  def change_current_station(station)
    current_station.send_train(self)
    current_station = station
    current_station.take_train(self)
  end

  def current_station_index
    route.stations.index(current_station)
  end
end






