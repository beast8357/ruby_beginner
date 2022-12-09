require_relative 'modules/seeds'

class App
  include Seeds

  def initialize
    @stations = {}
    @routes = {}
    @trains = {}
    load_seeds
  end

  def menu
    loop do
      actions_list
      prompt
      input = gets.chomp
      raise "Empty Input. Retry with an appropriate input." if input.empty?
      input = input.to_i
      case input 
        when 1
          create_station
        when 2
          create_train
        when 3
          create_route
        when 4
          add_station
        when 5
          remove_station
        when 6
          assign_route
        when 7
          add_car
        when 8
          unhook_car
        when 9
          occupy
        when 10
          move_train(:forward)
        when 11
          move_train(:back)
        when 12
          train_cars
        when 13
          route_stations
        when 14
          trains_at_station
        when 15
          goodbye
        else
          raise "Input must be a number in range 1-15."
      end
    end

    rescue StandardError => e
      puts e.message
      retry
  end

  private
  
  attr_reader :stations, :routes, :trains

  def actions_list
    list = <<~HEREDOC
    ============ TO PERFORM AN ACTION, ENTER ITS NUMBER ============
    | 1. Create a station                                          |
    | 2. Create a train                                            |
    | 3. Create a route                                            |
    | 4. Add a station to a route                                  |
    | 5. Remove a station from a route                             |
    | 6. Assign a route to a train                                 |
    | 7. Add a car to a train                                      |
    | 8. Unhook the last car from a train                          |
    | 9. Take a seat or volume in a car                            |
    | 10. Move a train to the next station                         |
    | 11. Move a train to the previous station                     |
    | 12. View the list of train cars                              |
    | 13. View the list of stations on a route                     |
    | 14. View the list of trains at a station                     |
    | 15. Quit                                                     |
    ================================================================
    HEREDOC
    puts list
  end

  def create_station
    puts "Enter the name of the station. " +
          "(Must consist of 1 word or 2 words with a space in-between)"
    prompt
    station_name = gets.chomp

    raise "Such station already exists." if
          stations.keys.include?(station_name)

    stations[station_name] = Station.new(station_name)

    status 
    puts "#{station_name} station has been successfully created!"

    rescue StandardError => e
      puts e.message
      retry
  end

  def create_train
    puts "To create a passenger train, enter 1.\n" +
         "To create a cargo train, enter 2.";
    prompt
    type = gets.chomp.to_i

    case type
      when 1
        type = :passenger
      when 2
        type = :cargo
      else
        raise "Input must be 1 or 2."
    end

    puts "Enter the train number " +
          "(Use letters and numbers in the format \'XXX-XX\' or \'XXXXX\')"
    prompt
    train_number = gets.chomp

    raise "Train with such number already exists." if 
          trains.keys.include?(train_number)

    case type
      when :passenger
        trains[train_number] = PassengerTrain.new(train_number)
        status
        puts "Passenger train #{train_number} has been successfully created!"
      when :cargo
        trains[train_number] = CargoTrain.new(train_number)
        status
        puts "Cargo train #{train_number} has been successfully created!"
    end

    rescue StandardError => e
      puts e.message
      retry
  end

  def create_route
    raise "At least 2 stations required." if stations.size < 2

    show_stations_names

    puts "Choose the starting station (Enter the number)."
    prompt
    number = gets.chomp.to_i

    raise "No such station." unless (1..stations.keys.size).include?(number)

    starting_station = get_station(number)
    

    puts "Choose the end station (Enter the number)."
    prompt
    number = gets.chomp.to_i

    raise "No such station." unless (1..stations.keys.size).include?(number)

    end_station = get_station(number)

    raise "This station is already the starting station. Choose another station." if
          end_station == starting_station

    route_name = "#{starting_station.name} - #{end_station.name}"

    raise "Such route already exists." if
          routes.keys.include?(route_name)

    routes[route_name] = Route.new(starting_station, end_station)

    status
    puts "Route <<#{route_name}>> has been successfully created!"

    rescue StandardError => e
      puts e.message
  end

  def add_station
    raise "No routes available." if routes.empty?

    show_routes_names

    puts "Choose the route you'd like to add a station to (Enter the number)."
    prompt
    number = gets.chomp.to_i

    raise "No such route." unless (1..routes.keys.size).include?(number)

    route = get_route(number)

    show_stations_names

    puts "Choose the station you'd like to add (Enter the number)."
    prompt
    number = gets.chomp.to_i

    raise "No such station." unless (1..stations.keys.size).include?(number)

    station = get_station(number)

    raise "Such station is already in the route." if
          route.stations.include?(station)

    route.add_station(station)

    status
    puts "#{station.name} station has been successfully added to the route!"

    rescue StandardError => e
      puts e.message
  end

  def remove_station
    raise "No routes available." if routes.empty?

    show_routes_names

    puts "Choose the route you'd like to remove a station from (Enter the number)."
    prompt
    number = gets.chomp.to_i

    raise "No such route." unless (1..routes.keys.size).include?(number)

    route = get_route(number)

    raise "There are only 2 stations on this route." if
          route.stations.size == 2

    show_route_stations(route)

    puts "Choose the station you'd like to remove (Enter the number)."
    prompt
    number = gets.chomp.to_i

    raise "No such station." unless (1..stations.keys.size).include?(number)

    station = route.stations[number - 1]

    case station
      when route.stations.first
        raise "You can't remove the starting station."
      when route.stations.last
        raise "You can't remove the end station."
    end

    route.remove_station(station)

    status
    puts "#{station.name} station has been successfully removed from the route!"

    rescue StandardError => e
      puts e.message
  end

  def assign_route
    raise "No trains available." if trains.empty?
    raise "No routes available." if routes.empty?

    show_trains_numbers

    puts "Choose the train you'd like to assign a route to (Enter the number)."
    prompt
    number = gets.chomp.to_i

    raise "No such train." unless (1..trains.keys.size).include?(number)

    train = get_train(number)

    show_routes_names

    puts "Choose the route you'd like to assign to the train (Enter the number)."
    prompt
    number = gets.chomp.to_i

    raise "No such route." unless (1..routes.keys.size).include?(number)

    route = get_route(number)

    starting_station_name = route.stations.first.name
    end_station_name = route.stations.last.name

    train.take_route(route)
    
    status
    puts "The route <<#{starting_station_name} - #{end_station_name}>> " +
          "has been successfully assigned to the train #{train.number}!"

    rescue StandardError => e
      puts e.message
  end

  def add_car
    raise "No trains available." if trains.empty?

    show_trains_numbers

    puts "Choose the train you'd like to add a car to (Enter the number)."
    prompt
    number = gets.chomp.to_i

    raise "No such train." unless (1..trains.keys.size).include?(number)

    train = get_train(number)

    case train.type
      when :passenger
        puts "Enter the number of seats in the car."
        prompt
        seats = gets.chomp.to_i

        raise "Input must be 0 or above." if seats < 0

        car = PassengerCar.new(seats)
      when :cargo
        puts "Enter the car's volume."
        prompt
        volume = gets.chomp.to_f

        raise "Input must be 0 or above." if volume < 0

        car = CargoCar.new(volume)
      else
        raise "Input must be 1 or 2."
    end

    train.add_car(car)

    status
    puts "The car has been successfully added!"

    rescue StandardError => e
      puts e.message
  end

  def unhook_car
    raise "No trains available." if trains.empty?

    show_trains_numbers

    puts "Choose the train you'd like to unhook the last car from (Enter the number)."
    prompt
    number = gets.chomp.to_i

    raise "No such train." unless (1..trains.keys.size).include?(number)

    train = get_train(number)

    raise "No cars to unhook." if train.cars.empty?

    train.unhook_car

    status
    puts "The car has been successfully unhooked!"

    rescue StandardError => e
      puts e.message
  end

  def occupy
    raise "No trains available." if trains.empty?

    show_trains_numbers

    puts "Choose the train (Enter the number)."
    prompt
    number = gets.chomp.to_i

    raise "No such train." unless (1..trains.keys.size).include?(number)

    train = get_train(number)

    raise "This train has no cars." if train.cars.empty?

    show_train_cars(train)

    puts "Choose the car (Enter the number)."
    prompt
    car_number = gets.chomp.to_i

    raise "No such car." unless (1..train.cars.size).include?(car_number)

    car = train.cars[car_number - 1]

    case car.type
      when :passenger
        car.take_seat
        status
        puts "A seat has been successfully taken!"
      when :cargo
        puts "Enter the volume you'd like to occupy."
        prompt
        volume = gets.chomp.to_f
        car.occupy_volume(volume)
        status
        puts "The volume has been successfully occupied!"
    end

    rescue StandardError => e
      puts e.message
  end

  def move_train(direction)
    raise "No trains available." if trains.empty?
    raise "No routes available." if routes.empty?

    show_trains_numbers

    case direction
      when :forward
        puts "Choose the train you'd like to move forward (Enter the number)."
        prompt
        number = gets.chomp.to_i

        raise "No such train." unless (1..trains.keys.size).include?(number)

        train = get_train(number)

        raise "The train is already at the end station." if
              train.current_station == train.route.stations.last
        
        train.to_next_station

        status
        arrival_message(train)
      when :back
        puts "Choose the train you'd like to move back (Enter the number)."
        prompt
        number = gets.chomp.to_i

        raise "No such train." unless (1..trains.keys.size).include?(number)

        train = get_train(number)

        raise "The train is already at the starting station." if
              train.current_station == train.route.stations.first

        train.to_previous_station

        status
        arrival_message(train)
    end

    rescue StandardError => e
      puts e.message
  end
  
  def train_cars
    raise "No trains available." if trains.empty?

    show_trains_numbers

    puts "Choose the train (Enter the number)."
    prompt
    number = gets.chomp.to_i

    raise "No such train." unless (1..trains.keys.size).include?(number)

    train = get_train(number)

    raise "This train has no cars." if train.cars.empty?

    show_train_cars(train)

    rescue StandardError => e
      puts e.message
  end

  def show_train_cars(train)
    train.each_car do |car, index|
      print "Number: #{index}, Type: #{car.type.to_s.capitalize!}, "

      case train.type
        when :passenger
          puts "Free seats: #{car.free_volume.to_i}, " +
                "Seats taken: #{car.occupied_volume.to_i}"
        when :cargo
          puts "Unoccupied volume: #{car.free_volume}, " +
                "Volume occupied: #{car.occupied_volume}"
      end
    end
  end

  def route_stations
    raise "No routes available." if routes.empty?

    show_routes_names

    puts "Choose the route (Enter the number)."
    prompt
    number = gets.chomp.to_i

    raise "No such route." unless (1..routes.keys.size).include?(number)

    route = get_route(number)

    puts "Stations on this route:"
    show_route_stations(route)

    rescue StandardError => e
      puts e.message
  end

  def show_route_stations(route)
    route.each_station { |station, index| puts "#{index}. #{station.name}" }
  end

  def trains_at_station
    raise "No trains available." if trains.empty?
    raise "No stations available." if stations.empty?

    show_stations_names

    puts "Choose the station (Enter the number)."
    prompt
    number = gets.chomp.to_i

    raise "No such station." unless (1..stations.keys.size).include?(number)

    station = get_station(number)

    raise "No trains on this station." if station.trains.empty?

    show_trains_at_station(station)

    rescue StandardError => e
      puts e.message
  end

  def show_trains_at_station(station)
    station.each_train do |train|
      puts "Number: #{train.number}, " +
            "Type: #{train.type.to_s.capitalize!}, " +
            "Cars amount: #{train.cars.size}"
    end
  end

  def show_trains_numbers
    trains.values.each.with_index(1) do |train, index|
      puts "#{index}. #{train.number}"
    end
  end

  def show_routes_names
    routes.keys.each.with_index(1) do |route_name, index|
      puts "#{index}. #{route_name}"
    end
  end

  def show_stations_names
    stations.values.each.with_index(1) do |station, index|
      puts "#{index}. #{station.name}"
    end
  end

  def get_station(number)
    stations[stations.keys[number - 1]]
  end

  def get_route(number)
    routes[routes.keys[number - 1]]
  end

  def get_train(number)
    trains[trains.keys[number - 1]]
  end

  def arrival_message(train)
    puts "The train has successfully arrived at #{train.current_station.name} station!"
  end

  def status
    print "Status: "
  end

  def prompt
    print "Your input: "
  end

  def goodbye
    puts "See you later!"
    exit
  end
end