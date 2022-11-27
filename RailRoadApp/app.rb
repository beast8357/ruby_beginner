class App
  def initialize
    @stations = {}
    @routes = {}
    @trains = {}
  end

  def menu
    loop do
      actions_list
      prompt
      input = gets.chomp
      raise "InputError: Empty Input." if input.empty?
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
          move_train(:forward)
        when 10
          move_train(:back)
        when 11
          route_stations
        when 12
          trains_at_station
        when 0
          goodbye
        else
          raise "InputError: Input must be in range 0-12."
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
    | 4. Add a station to the route                                |
    | 5. Remove a station from the route                           |
    | 6. Assign a route to the train                               |
    | 7. Add a car to the train                                    |
    | 8. Unhook a car from the train                               |
    | 9. Move the train to the next station                        |
    | 10. Move the train to the previous station                   |
    | 11. View the list of stations on the route                   |
    | 12. View the list of trains at the station                   |
    | 0. Quit                                                      |
    ================================================================
    HEREDOC
    puts list
  end

  def create_station
    puts "Enter the name of the station. " +
          "(Must consist of 1 word or 2 words with a space in-between)"
    prompt
    station_name = gets.chomp

    raise "InputError: Such station already exists." if
          stations.keys.include?(station_name)

    stations[station_name] = Station.new(station_name)
    status 
    puts "#{station_name} station has been created!"

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
        raise "InputError: Input must be 1 or 2."
    end

    puts "Enter the train number " +
          "(Use letters and numbers in the format \'XXX-XX\' or \'XXXXX\')"
    prompt
    number = gets.chomp

    raise "InputError: Train with such number already exists." if 
          trains.keys.include?(number)

    case type
      when :passenger
        trains[number] = PassengerTrain.new(number)
        status
        puts "Passenger train #{number} has been created!"
      when :cargo
        trains[number] = CargoTrain.new(number)
        status
        puts "Cargo train #{number} has been created!"
    end

    rescue StandardError => e
      puts e.message
      retry
  end

  def create_route
    raise "NotEnoughStationsError: At least 2 stations required." if stations.size < 2

    show_stations_names

    puts "Enter the starting station name."
    prompt
    starting_station_name = gets.chomp
    raise "InputError: No such station." if
          !stations.keys.include?(starting_station_name)
    starting_station = stations[starting_station_name]

    puts "Enter the end station name."
    prompt
    end_station_name = gets.chomp
    raise "InputError: No such station." if !stations.keys.include?(end_station_name)
    end_station = stations[end_station_name]

    route_name = "#{starting_station_name}-#{end_station_name}"
    routes[route_name] = Route.new(starting_station, end_station)
    status
    puts "Route <<#{route_name}>> has been created!"

    rescue StandardError => e
      puts e.message
  end

  def add_station
    raise "NoRoutesError: No routes available." if routes.empty?

    show_routes_names

    puts "Enter the name of the route you'd like to add the station to."
    prompt
    route_name = gets.chomp
    raise "InputError: No such route." if !routes.keys.include?(route_name)
    route = get_route(route_name)

    show_stations_names

    puts "Enter the name of the station you'd like to add."
    prompt
    station_name = gets.chomp
    raise "InputError: No such station." if !stations.keys.include?(station_name)
    station = get_station(station_name)

    raise "InputError: Such station is alredy in the route." if
          route.stations.include?(station)

    route.add_station(station)
    status
    puts "#{station_name} station has been added to the route!"

    rescue StandardError => e
      puts e.message
  end

  def remove_station
    raise "NoRoutesError: No routes available." if routes.empty?

    show_routes_names

    puts "Enter the name of the route you'd like to remove the station from."
    prompt
    route_name = gets.chomp
    raise "InputError: No such route." if !routes.keys.include?(route_name)
    route = get_route(route_name)

    show_route_stations(route)

    puts "Enter the name of the station you'd like to remove."
    prompt
    station_name = gets.chomp
    raise "InputError: No such station." if !stations.keys.include?(station_name)
    station = get_station(station_name)

    raise "ImpossibleActionError: Routes can't have less than 2 stations." if
          route.stations.size < 3

    route.remove_station(station)
    status
    puts "#{station_name} station has been removed from the route!"

    rescue StandardError => e
      puts e.message
  end

  def assign_route
    raise "NoTrainsError: No trains available." if trains.empty?
    raise "NoRoutesError: No routes available." if routes.empty?

    show_trains_numbers

    puts "Enter the number of the train you'd like to assign a route to."
    prompt
    number = gets.chomp
    raise "InputError: No such train." if !trains.keys.include?(number)
    train = get_train(number)

    show_routes_names

    puts "Enter the name of the route you'd like to assign to the train."
    prompt
    route_name = gets.chomp
    raise "InputError: No such route." if !routes.keys.include?(route_name)
    route = get_route(route_name)

    train.take_route(route)
    status
    puts "The route <<#{route_name}>> has been assigned to the train #{number}!"

    rescue StandardError => e
      puts e.message
  end

  def add_car
    raise "NoTrainsError: No trains available." if trains.empty?

    show_trains_numbers

    puts "Enter the number of the train you'd like to add a car to."
    prompt
    number = gets.chomp
    raise "InputError: No such train." if !trains.keys.include?(number)
    train = get_train(number)

    puts "What type of car would you like to create?\n" +
        "Enter 1 to make it passenger;\n" +
        "Enter 2 to make it cargo.";
    prompt
    type = gets.chomp.to_i

    case type
      when 1
        car = PassengerCar.new
      when 2
        car = CargoCar.new
      else
        raise "InputError: Input must be 1 or 2."
    end

    raise "TypesIncompatibilityError: The types of car and train are different." if
          car.type != train.type

    train.add_car(car)
    car_adding_success_message

    rescue StandardError => e
      puts e.message
  end

  def unhook_car
    raise "NoTrainsError: No trains available." if trains.empty?

    show_trains_numbers

    puts "Enter the number of the train you'd like to unhook a car from."
    prompt
    number = gets.chomp
    raise "InputError: No such train." if !trains.keys.include?(number)
    train = get_train(number)

    raise "NoCarsError: No cars to unhook." if train.cars.empty?

    train.unhook_car
    status
    puts "The car has been unhooked!"

    rescue StandardError => e
      puts e.message
  end

  def move_train(direction)
    raise "NoTrainsError: No trains available." if trains.empty?
    raise "NoRoutesError: No routes available." if routes.empty?

    show_trains_numbers

    case direction
      when :forward
        puts "Enter the number of the train you'd like to move forward."
        prompt
        number = gets.chomp
        raise "InputError: No such train." if !trains.keys.include?(number)
        train = get_train(number)

        raise "MovementError: The train is at the end station." if
              train.next_station.nil?
        
        train.to_next_station
        arrival_message(train)
      when :back
        puts "Enter the number of the train you'd like to move back."
        prompt
        number = gets.chomp
        raise "InputError: No such train." if !trains.keys.include?(number)
        train = get_train(number)

        raise "MovementError: The train is at the starting station." if
              train.previous_station.nil?

        train.to_previous_station
        arrival_message(train)
    end

    rescue StandardError => e
      puts e.message
  end
  
  def route_stations
    raise "NoRoutesError: No routes available." if routes.empty?

    show_routes_names

    puts "Enter the name of the route."
    prompt
    route_name = gets.chomp
    raise "InputError: No such route." if !routes.keys.include?(route_name)
    route = get_route(route_name)

    show_route_stations(route)

    rescue StandardError => e
      puts e.message
  end

  def trains_at_station
    raise "NoTrainsError: No trains available." if trains.empty?
    raise "NoStationsError: No stations available." if stations.empty?

    show_stations_names

    puts "Enter the name of the station."
    prompt
    station_name = gets.chomp
    raise "InputError: No such station." if !stations.keys.include?(station_name)
    station = get_station(station_name)

    show_trains_at_station(station)

    rescue StandardError => e
      puts e.message
  end

  def show_route_stations(route)
    stations_list = route.stations
    puts "Current route stations:"
    stations_list.each.with_index(1) do |station, index|
      puts "#{index}. #{station.name}"
    end
  end

  def show_trains_at_station(station)
    trains_list = station.trains
    puts "Trains at this station:"
    trains_list.each.with_index(1) do |train, index|
      puts "#{index}. #{train.number}"
    end
  end

  def show_routes_names
    routes.keys.each.with_index(1) do |route_name, index|
      puts "#{index}. #{route_name}"
    end
  end

  def show_trains_numbers
    trains.values.each.with_index(1) do |train, index|
      puts "#{index}. #{train.number}"
    end
  end

  def show_stations_names
    stations.values.each.with_index(1) do |station, index|
      puts "#{index}. #{station.name}"
    end
  end

  def get_station(station_name)
    stations[station_name]
  end

  def get_route(route_name)
    routes[route_name]
  end

  def get_train(number)
    trains[number]
  end

  def car_adding_success_message
    status
    puts "The car has been added to the train!"
  end

  def arrival_message(train)
    status
    puts "The train has arrived at #{train.current_station.name} station!"
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