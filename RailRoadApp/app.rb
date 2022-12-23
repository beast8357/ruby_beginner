require_relative 'modules/seeds/seeds'
require_relative 'modules/menu'

class App
  include Seeds
  include Menu

  def initialize
    @stations = {}
    @routes = {}
    @trains = {}
    load_seeds
  end

  def start
    loop do
      display_menu
      input = gets.chomp.to_i
      raise 'Invalid input.' unless (1..15).include?(input)

      item = MENU[input - 1]
      send(item[:action])
    end
  rescue => e
    puts e.message
    retry
  end

  private

  attr_reader :stations, :routes, :trains

  def create_station
    puts 'Enter the name of the station (Must be 1 or 2 words)'
    name = gets.chomp
    raise 'Such station already exists.' if stations.keys.include?(name)

    stations[name] = Station.new(name)
    puts "#{name} station has been successfully created!"
  end

#######################################################################################
  def create_train
    type = set_train_type
    number = set_train_number
    trains[number] = PassengerTrain.new(number) if type == :passenger
    trains[number] = CargoTrain.new(number) if type == :cargo
    puts "The train #{number} has been successfully created!"
  end

  def set_train_type
    puts "To create a passenger train, enter 1.\n" \
         'To create a cargo train, enter 2.'
    input = gets.chomp.to_i
    raise 'Input must be 1 or 2.' unless (1..2).include?(input)

    return :passenger if input == 1
    return :cargo if input == 2
  rescue => e
    puts e.message
    retry
  end

  def set_train_number
    puts 'Enter the train number ' \
          "(Use letters and numbers in the format \'XXX-XX\' or \'XXXXX\')"
    number = gets.chomp
    raise 'Train with such number already exists.' if
          trains.keys.include?(number)

    number
  end
#######################################################################################

#=====================================================================================#
  def create_route
    raise "Less than 2 stations created." if stations.size < 2

    display_stations_names
    puts 'Choose the starting station (Enter the number).'
    starting_station = select_station
    puts 'Choose the end station (Enter the number).'
    end_station = select_station
    set_name_and_create(starting_station, end_station)
  end

  def set_name_and_create(starting_station, end_station)
    route_name = "#{starting_station.name} - #{end_station.name}"
    raise 'Such route already exists.' if routes.keys.include?(route_name)

    route_args = { starting_station: starting_station, end_station: end_station }
    routes[route_name] = Route.new(route_args)
    puts "Route <<#{route_name}>> has been successfully created!"
  end
#=====================================================================================#

#######################################################################################
  def add_station
    raise "No routes available." if routes.empty?

    display_routes_names
    puts "Choose the route you'd like to add a station to (Enter the number)."
    route = select_route
    display_stations_names
    puts "Choose the station you'd like to add (Enter the number)."
    station = select_station
    raise 'Such station is already on the route.' if route.stations.include?(station)

    route.add_station(station)
    puts "#{station.name} station has been successfully added to the route!"
  end
#######################################################################################

#=====================================================================================#
  def remove_station
    raise "No routes available." if routes.empty?

    display_routes_names
    puts "Choose the route you'd like to remove a station from (Enter the number)."
    route = select_route
    display_route_stations(route)
    puts "Choose the station you'd like to remove (Enter the number)."
    station = select_station_to_remove(route)
    route.remove_station(station) if removable?(station, route)
    puts "#{station.name} station has been successfully removed from the route!"
  end

  def select_station_to_remove(route)
    input = gets.chomp.to_i
    raise 'No such station.' unless (1..route.stations.size).include?(input)

    route.stations[input - 1]
  end

  def removable?(station, route)
    case station
    when route.stations.first
      raise "You can't remove the starting station."
    when route.stations.last
      raise "You can't remove the end station."
    else
      true
    end
  end
#=====================================================================================#

#######################################################################################
  def assign_route
    raise "No trains available." if trains.empty?
    raise "No routes available." if routes.empty?

    display_trains_numbers
    puts "Choose the train you'd like to assign a route to (Enter the number)."
    train = select_train
    display_routes_names
    puts "Choose the route you'd like to assign to the train (Enter the number)."
    route = select_route
    assign(route, train)
  end

  def assign(route, train)
    starting_station_name = route.stations.first.name
    end_station_name = route.stations.last.name
    train.take_route(route)
    puts "The route <<#{starting_station_name} - #{end_station_name}>> " \
          "has been successfully assigned to the train #{train.number}!"
  end
#######################################################################################

#=====================================================================================#
  def add_car
    raise "No trains available." if trains.empty?

    display_trains_numbers
    puts "Choose the train you'd like to add a car to (Enter the number)."
    train = select_train
    car = create_car(train)
    train.add_car(car)
    puts 'The car has been successfully added!'
  end

  def create_car(train)
    case train.type
    when :passenger
      seats = set_seats_number
      car = PassengerCar.new(seats)
    when :cargo
      volume = set_volume
      car = CargoCar.new(volume)
    end

    car
  end

  def set_seats_number
    puts 'Enter the number of seats in the car.'
    get_input_and_check
  end

  def set_volume
    puts "Enter the car's volume."
    get_input_and_check
  end

  def get_input_and_check
    input = gets.chomp.to_f
    raise 'Input must be 1 or above.' if input.zero? || input.negative?

    input
  rescue => e
    puts e.message
    retry
  end
#=====================================================================================#

#######################################################################################
  def unhook_car
    raise "No trains available." if trains.empty?

    display_trains_numbers
    puts "Choose the train you'd like to unhook the last car from (Enter the number)."
    train = select_train
    raise 'No cars to unhook.' if train.cars.empty?

    train.unhook_car
    puts 'The car has been successfully unhooked!'
  end
#######################################################################################

#=====================================================================================#
  def occupy
    raise "No trains available." if trains.empty?

    display_trains_numbers
    puts 'Choose the train (Enter the number).'
    train = select_train
    raise 'This train has no cars.' if train.cars.empty?

    display_train_cars(train)
    puts 'Choose the car (Enter the number).'
    car = select_car(train)
    take_seat_or_occupy_volume(car)
  end

  def select_car(train)
    car_number = gets.chomp.to_i
    raise 'No such car.' unless (1..train.cars.size).cover?(car_number)

    train.cars[car_number - 1]
  end

  def take_seat_or_occupy_volume(car)
    case car.type
    when :passenger
      car.take_seat
      puts 'A seat has been successfully taken!'
    when :cargo
      puts "Enter the volume you'd like to occupy."
      volume = gets.chomp.to_f
      car.occupy_volume(volume)
      puts 'The volume has been successfully occupied!'
    end
  end
#=====================================================================================#

#######################################################################################
  def move_train_forward
    move_train(:forward)
  end

  def move_train_backwards
    move_train(:backwards)
  end

  def move_train(direction)
    raise "No trains available." if trains.empty?
    raise "No routes available." if routes.empty?

    display_trains_numbers
    display_movement_options(direction)
    train = select_train
    raise "No route has been assigned to this train." if train.current_station.nil?

    forward(train) if direction == :forward
    backwards(train) if direction == :backwards
    puts 'The train has successfully arrived at ' \
          "#{train.current_station.name} station!"
  end

  def display_movement_options(direction)
    where(:forward) if direction == :forward
    where(:backwards) if direction == :backwards
  end

  def where(direction)
    puts "Choose the train you'd like to move #{direction} (Enter the number)."
  end

  def forward(train)
    raise 'The train is already at the end station.' if
          train.current_station == train.route.stations.last

    train.to_next_station
  end

  def backwards(train)
    raise 'The train is already at the starting station.' if
          train.current_station == train.route.stations.first

    train.to_previous_station
  end
#######################################################################################

#=====================================================================================#
  def train_cars
    raise 'No trains available.' if trains.empty?

    display_trains_numbers
    puts 'Choose the train (Enter the number).'
    train = select_train
    raise 'This train has no cars.' if train.cars.empty?

    display_train_cars(train)
  end

  def display_train_cars(train)
    train.each_car { |car, index| display_car_characteristics(train, car, index) }
  end

  def display_car_characteristics(train, car, index)
    print "Number: #{index}, Type: #{car.type.to_s.capitalize!}, "
    case train.type
    when :passenger
      puts "Free seats: #{car.free_volume.to_i}, " \
            "Seats taken: #{car.occupied_volume.to_i}"
    when :cargo
      puts "Unoccupied volume: #{car.free_volume}, " \
            "Volume occupied: #{car.occupied_volume}"
    end
  end
#=====================================================================================#

#######################################################################################
  def route_stations
    raise "No routes available." if routes.empty?

    display_routes_names
    puts 'Choose the route (Enter the number).'
    route = select_route
    puts 'Stations on this route:'
    display_route_stations(route)
  end

  def display_route_stations(route)
    route.each_station { |station, index| puts "#{index}. #{station.name}" }
  end
#######################################################################################

#=====================================================================================#
  def trains_at_station
    raise "No trains available." if trains.empty?
    raise "No stations available." if stations.empty?

    display_stations_names
    puts 'Choose the station (Enter the number).'
    station = select_station
    raise 'No trains at this station.' if station.trains.empty?

    display_trains_at_station(station)
  end

  def display_trains_at_station(station)
    station.each_train { |train| puts train_characteristics(train) }
  end

  def train_characteristics(train)
    "Number: #{train.number}, " \
    "Type: #{train.type.to_s.capitalize!}, " \
    "Cars amount: #{train.cars.size}"
  end
#=====================================================================================#

  def display_trains_numbers
    trains.each_value.with_index(1) do |train, index|
      puts "#{index}. #{train.number}"
    end
  end

  def display_routes_names
    routes.each_key.with_index(1) do |route_name, index|
      puts "#{index}. #{route_name}"
    end
  end

  def display_stations_names
    stations.each_value.with_index(1) do |station, index|
      puts "#{index}. #{station.name}"
    end
  end

  def select_train
    input = gets.chomp.to_i
    raise 'No such train.' unless (1..trains.keys.size).cover?(input)

    get_train(input)
  end

  def select_route
    input = gets.chomp.to_i
    raise 'No such route.' unless (1..routes.keys.size).cover?(input)

    get_route(input)
  end

  def select_station
    input = gets.chomp.to_i
    raise 'No such station.' unless (1..stations.keys.size).cover?(input)

    get_station(input)
  end

  def get_train(number)
    trains[trains.keys[number - 1]]
  end

  def get_route(number)
    routes[routes.keys[number - 1]]
  end

  def get_station(number)
    stations[stations.keys[number - 1]]
  end

  def display_menu
    puts '============ TO PERFORM AN ACTION, ENTER ITS NUMBER ============'
    MENU.each.with_index(1) { |item, index| puts "#{index}. #{item[:option]}" }
    puts '================================================================'
  end

  def goodbye
    puts 'See you later!'
    exit
  end
end
