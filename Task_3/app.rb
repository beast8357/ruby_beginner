class App
  def initialize
    @stations = {}
    @routes = {}
    @trains = {}
    @status = "Status:"
    @prompt = "Your input: "
  end

  def menu
    actions_list = <<~HEREDOC
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

    loop do
      puts actions_list
      print "#{@prompt}"
      input = gets.chomp.to_i
      exit if input.zero?
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
          show_routes_names
          puts "Enter the name of the route."
          print "#{@prompt}"
          route_name = gets.chomp
          route = get_route(route_name)
          show_route_stations(route)
        when 12
          show_stations_names
          puts "Enter the name of the station."
          print "#{@prompt}"
          station_name = gets.chomp
          station = get_station(station_name)
          show_trains_at_station(station)
        when 0
          puts "See you later!"
          break
      end
    end
  end

  def create_station
    puts "Enter the name of the station."
    print "#{@prompt}"
    station_name = gets.chomp
    if @stations[station_name].nil?
      @stations[station_name] = Station.new(station_name)
      puts "#{@status} #{station_name} station has been created!"
    else
      puts "#{@status} #{station_name} station already exists!"
    end
  end

  def create_train
    puts "To create a passenger train, enter 1.\n" +
         "To create a cargo train, enter 2.";
    print "#{@prompt}"
    type = gets.chomp.to_i
    case type
      when 1
        type = :passenger
      when 2
        type = :cargo
    end
    puts "Enter the train number."
    print "#{@prompt}"
    number = gets.chomp
    case type
      when :passenger
        number = "P-" + number
        if @trains[number].nil?
          @trains[number] = PassengerTrain.new(number)
          puts "#{@status} Passenger train #{number} has been created!"
        else
          puts "#{@status} Passenger train #{number} already exists!"
        end
      when :cargo
        number = "C-" + number
        if @trains[number].nil?
          @trains[number] = CargoTrain.new(number)
          puts "#{@status} Cargo train #{number} has been created!"
        else
          puts "#{@status} Cargo train #{number} already exists!"
        end
    end
  end

  def create_route
    if @stations.empty?
      puts "#{@status} No stations available!"
    else
      show_stations_names
      puts "Enter the starting station name."
      print "#{@prompt}"
      starting_station_name = gets.chomp
      puts "Enter the end station name."
      print "#{@prompt}"
      end_station_name = gets.chomp
      starting_station = @stations[starting_station_name]
      end_station = @stations[end_station_name]
      route_name = "#{starting_station_name}-#{end_station_name}"
      @routes[route_name] = Route.new(starting_station, end_station)
      puts "#{@status} Route <<#{route_name}>> has been created!"
    end
  end

  def add_station
    if @routes.empty?
      puts "#{@status} No routes available!"
    else
      show_routes_names
      puts "Enter the name of the route you'd like to add the station to."
      print "#{@prompt}"
      route_name = gets.chomp
      show_stations_names
      puts "Enter the name of the station you'd like to add."
      print "#{@prompt}"
      station_name = gets.chomp
      route = get_route(route_name)
      station = get_station(station_name)
      route.add_station(station)
      puts "#{@status} #{station_name} station has been added to the route!"
    end 
  end

  def remove_station
    show_routes_names
    puts "Enter the name of the route you'd like to remove the station from."
    print "#{@prompt}"
    route_name = gets.chomp
    route = get_route(route_name)
    show_route_stations(route)
    puts "Enter the name of the station you'd like to remove."
    print "#{@prompt}"
    station_name = gets.chomp
    station = get_station(station_name)
    if route.stations.include?(station)
      route.remove_station(station)
      puts "#{@status} #{station_name} station has been removed from the route!"
    end
  end

  def assign_route
    show_trains_numbers
    puts "Enter the number of the train you'd like to assign a route to."
    print "#{@prompt}"
    number = gets.chomp
    show_routes_names
    puts "Enter the name of the route you'd like to assign to the train."
    print "#{@prompt}"
    route_name = gets.chomp
    train = get_train(number)
    route = get_route(route_name)
    train.take_route(route)
    puts "#{@status} The route <<#{route_name}>> has been assigned to the train #{number}!"
  end

  def add_car
    show_trains_numbers
    puts "Enter the number of the train you'd like to add a car to."
    print "#{@prompt}"
    number = gets.chomp
    train = get_train(number)
    puts "What type of car would you like to create?\n" +
        "Enter 1 to make it passenger;\n" +
        "Enter 2 to make it cargo.";
    print "#{@prompt}"
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
        puts "#{@status} Can't add cargo cars to this train!"
      end
    elsif train.type == :cargo
      if car.type == :cargo
        train.add_car(car)
        car_adding_success_message
      elsif car.type == :passenger
        puts "#{@status} Can't add passenger cars to this train!"  
      end
    end
  end

  def unhook_car
    show_trains_numbers
    puts "Enter the number of the train you'd like to unhook a car from."
    print "#{@prompt}"
    number = gets.chomp
    train = get_train(number)
    if train.cars.empty?
      puts "#{@status} No cars to remove!"
    else
      train.unhook_car(train.cars.last)
      puts "#{@status} The car has been unhooked!"
    end
  end

  def show_route_stations(route)
    stations_list = route.stations
    puts "Current route stations:"
    stations_list.each do |station|
      iterator = 0
      puts "#{iterator += 1}. #{station.name}"
    end
  end

  def show_trains_at_station(station)
    trains_list = station.trains
    puts "Trains at this station:"
    trains_list.each do |train|
      iterator = 0
      puts "#{iterator += 1}. #{train.number}"
    end
  end

# Реализация методов ниже скрыта в целях обеспечения стабильности работы приложения

  private

  def move_train(direction)
    show_trains_numbers
    case direction
      when :forward
        puts "Enter the number of the train you'd like to move forward."
        print "#{@prompt}"
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
        print "#{@prompt}"
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

  def show_routes_names
    iterator = 0
    @routes.keys.each do |route_name|
      puts "#{iterator += 1}. #{route_name}"
    end
  end

  def show_trains_numbers
    iterator = 0
    @trains.values.each do |train|
      puts "#{iterator += 1}. #{train.number}"
    end
  end

  def show_stations_names
    @stations.values.each do |station|
      puts station.name
    end
  end

  def get_station(station_name)
    @stations[station_name]
  end

  def get_route(route_name)
    @routes[route_name]
  end

  def get_train(number)
    @trains[number]
  end

  def car_adding_success_message
    puts "#{@status} The car has been successfully added to the train!"
  end

  def arrival_message(train)
    puts "#{@status} The train has arrived at #{train.current_station.name} station!"
  end
end