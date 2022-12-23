module Menu
  MENU = [
    { option: 'Create a station', action: :create_station },
    { option: 'Create a train', action: :create_train },
    { option: 'Create a route', action: :create_route },
    { option: 'Add a station to the route', action: :add_station },
    { option: 'Remove a station from the route', action: :remove_station },
    { option: 'Assign a route to the train', action: :assign_route },
    { option: 'Add a car to the train', action: :add_car },
    { option: 'Unhook the last car from the train', action: :unhook_car },
    { option: 'Take a seat or volume in the car', action: :occupy },
    { option: 'Move a train to the next station', action: :move_train_forward },
    { option: 'Move a train to the previous station', action: :move_train_backwards },
    { option: 'View the list of train cars', action: :train_cars },
    { option: 'View the list of stations on the route', action: :route_stations },
    { option: 'View the list of trains at the station', action: :trains_at_station },
    { option: 'Quit', action: :goodbye }
  ].freeze
end
