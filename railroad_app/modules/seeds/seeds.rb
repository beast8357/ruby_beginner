require_relative 'station_seeds'
require_relative 'route_seeds'
require_relative 'train_seeds'
require_relative 'car_seeds'
require_relative 'assign_route_seeds'

module Seeds
  include StationSeeds
  include RouteSeeds
  include TrainSeeds
  include CarSeeds
  include AssignRouteSeeds

  def load_seeds
    create_stations
    create_routes
    add_stations
    create_trains
    add_cars
    assign_routes
  end
end
