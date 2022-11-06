class Train
  attr_accessor :speed
  attr_reader :number, :type, :cars, :speed, :route, :stations, :current_station

  def initialize(number, type, cars)
    @number = number
    @type = type.downcase.capitalize
    @cars = cars
    @speed = 0
  end

  def gain_speed(value)
    @speed += value
    puts "Speed increased by #{value}."
  end

  def show_speed
    puts "Current speed: #{@speed}."
  end

  def brake(value)
    @speed -= value
    if @speed > 0
      puts "Speed decreased by #{value}."
    else
      puts "The train stopped."
    end
  end

  def show_cars
    puts "Current cars number: #{@cars}."
  end

  def remove_car
    if @speed == 0
      if @cars > 0
        @cars -= 1
        puts "Car removed."
      else
        puts "Can't perform the action: The number of cars should be greated than 0."
      end
    else
      puts "The train must stop in order to remove a car."
    end
  end

  def add_car
    if @speed == 0
      @cars += 1
      puts "Car added."
    else
      puts "The train must stop in order to add a car."
    end
  end

  def take_route(route)
    @route = route
    @current_station = @route.stations.first
    @current_station.take_train(self)
    puts "Route has been taken by Train #{self.number}."
  end
  
  def go_to_next_station
    return if next_station.nil?
    change_current_station(next_station)
  end  

  def go_to_previous_station
    return if previous_station.nil?
    change_current_station(previous_station)
  end

  def show_current_station
    puts "The current station is #{@current_station.name}."
  end

  def change_current_station(station)
    @current_station.send_train(self)
    @current_station = station
    @current_station.take_train(self)
    arrival_message
  end
  
  def next_station
    if @route.stations[current_station_index] == @route.stations.last
      puts "The current station is end station!"
    else
      @route.stations[current_station_index + 1]
    end
  end

  def previous_station
    if @route.stations[current_station_index] == @route.stations.first
      puts "The current station is starting station!"
    else
      @route.stations[current_station_index - 1]
    end
  end

  def current_station_index
    @route.stations.index(@current_station)
  end

  def arrival_message
    puts "Train #{self.number} successfully arrived at station #{@current_station.name}."
  end
end


