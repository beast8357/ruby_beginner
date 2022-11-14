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
      next if input.empty?
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
      end
    end
  end

=begin
  Атрибуты класса, а также методы, реализующие функционал приложения,
  скрыты с целью закрыть к ним доступ вне данного класса
=end
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
    puts "Enter the name of the station."
    prompt
    station_name = gets.chomp
    if stations[station_name].nil?
      stations[station_name] = Station.new(station_name)
      status 
      puts "#{station_name} station has been created!"
    else
      status
      puts "#{station_name} station already exists!"
    end
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
    end
    puts "Enter the train number."
    prompt
    number = gets.chomp
    case type
      when :passenger
        number = "P-" + number
        if trains[number].nil?
          trains[number] = PassengerTrain.new(number)
          status
          puts "Passenger train #{number} has been created!"
        else
          status
          puts "Passenger train #{number} already exists!"
        end
      when :cargo
        number = "C-" + number
        if trains[number].nil?
          trains[number] = CargoTrain.new(number)
          status
          puts "Cargo train #{number} has been created!"
        else
          status
          puts "Cargo train #{number} already exists!"
        end
    end
  end

  def create_route
    if stations.empty?
      status
      puts "No stations available!"
    else
      show_stations_names
      puts "Enter the starting station name."
      prompt
      starting_station_name = gets.chomp
      puts "Enter the end station name."
      prompt
      end_station_name = gets.chomp
      starting_station = stations[starting_station_name]
      end_station = stations[end_station_name]
      route_name = "#{starting_station_name}-#{end_station_name}"
      routes[route_name] = Route.new(starting_station, end_station)
      status
      puts "Route <<#{route_name}>> has been created!"
    end
  end

  def add_station
    if routes.empty?
      status
      puts "No routes available!"
    else
      show_routes_names
      puts "Enter the name of the route you'd like to add the station to."
      prompt
      route_name = gets.chomp
      show_stations_names
      puts "Enter the name of the station you'd like to add."
      prompt
      station_name = gets.chomp
      route = get_route(route_name)
      station = get_station(station_name)
      route.add_station(station)
      status
      puts "#{station_name} station has been added to the route!"
    end 
  end

  def remove_station
    show_routes_names
    puts "Enter the name of the route you'd like to remove the station from."
    prompt
    route_name = gets.chomp
    route = get_route(route_name)
    show_route_stations(route)
    puts "Enter the name of the station you'd like to remove."
    prompt
    station_name = gets.chomp
    station = get_station(station_name)
    if route.stations.include?(station)
      route.remove_station(station)
      status
      puts "#{station_name} station has been removed from the route!"
    end
  end

  def assign_route
    show_trains_numbers
    puts "Enter the number of the train you'd like to assign a route to."
    prompt
    number = gets.chomp
    show_routes_names
    puts "Enter the name of the route you'd like to assign to the train."
    prompt
    route_name = gets.chomp
    train = get_train(number)
    route = get_route(route_name)
    train.take_route(route)
    status
    puts "The route <<#{route_name}>> has been assigned to the train #{number}!"
  end

  def add_car
    show_trains_numbers
    puts "Enter the number of the train you'd like to add a car to."
    prompt
    number = gets.chomp
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
    end

    if train.type == :passenger
      if car.type == :passenger
        train.add_car(car)
        car_adding_success_message
      elsif car.type == :cargo
        status
        puts "Can't add cargo cars to this train!"
      end
    elsif train.type == :cargo
      if car.type == :cargo
        train.add_car(car)
        car_adding_success_message
      elsif car.type == :passenger
        status
        puts "Can't add passenger cars to this train!"  
      end
    end
  end

  def unhook_car
    show_trains_numbers
    puts "Enter the number of the train you'd like to unhook a car from."
    prompt
    number = gets.chomp
    train = get_train(number)
    if train.cars.empty?
      status
      puts "No cars to remove!"
    else
      train.unhook_car(train.cars.last)
      status
      puts "The car has been unhooked!"
    end
  end

  def move_train(direction)
    show_trains_numbers
    case direction
      when :forward
        puts "Enter the number of the train you'd like to move forward."
        prompt
        number = gets.chomp
        train = get_train(number)
        if train.next_station.nil?
          puts "Can't move forward: The train is at the end station!"
        else
          train.to_next_station
          arrival_message(train)
        end
      when :back
        puts "Enter the number of the train you'd like to move back."
        prompt
        number = gets.chomp
        train = get_train(number)
        if train.previous_station.nil?
          puts "Can't move back: The train is at the starting station!"
        else
          train.to_previous_station
          arrival_message(train)
        end
    end
  end

  def route_stations
    show_routes_names
    puts "Enter the name of the route."
    prompt
    route_name = gets.chomp
    route = get_route(route_name)
    show_route_stations(route)
  end

  def trains_at_station
    show_stations_names
    puts "Enter the name of the station."
    prompt
    station_name = gets.chomp
    station = get_station(station_name)
    show_trains_at_station(station)
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
    stations.values.each do |station|
      puts station.name
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
    puts "The car has been successfully added to the train!"
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