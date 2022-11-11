class Train
  attr_reader :number, :type, :cars, :speed, :current_station

  def initialize(number)
    @number = number
    @cars = []
    @speed = 0
  end

  def gain_speed(value)
    @speed += value
  end

  def brake(value)
    @speed -= value
    @speed = 0 if @speed < 0
  end

  def add_car(car)
    @cars.push(car) if @speed == 0
  end

  def unhook_car(car)
    if @speed == 0
      @cars.delete(car) if @cars.size > 0 
    end
  end

  def take_route(route)
    @route = route
    @current_station = @route.stations.first
    @current_station.take_train(self)
  end

  def to_next_station
    change_current_station(next_station)
  end  

  def to_previous_station
    change_current_station(previous_station)
  end

  def next_station
    @route.stations[current_station_index + 1] if @route.stations[current_station_index] != @route.stations.last
  end

  def previous_station
    @route.stations[current_station_index - 1] if @route.stations[current_station_index] != @route.stations.first
  end

  protected

=begin
  Метод change_current_station помещен под protected, т.к. вызов него вне методов
  to_next_station и to_previous_station
  1. Не имеет смысла
  2. При неправильном вызове (при отсутствии или передаче неправильного аргумента)
  выдаст ошибку и сломает программу
=end
  def change_current_station(station)
    @current_station.send_train(self)
    @current_station = station
    @current_station.take_train(self)
  end

=begin
  Метод current_station_index помещен под protected, т.к. вызов него вне методов
  next_station и previous_station не имеет смысла
=end
  def current_station_index
    @route.stations.index(@current_station)
  end
end






