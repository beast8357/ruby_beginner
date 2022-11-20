require_relative "modules/instance_counter"

class Route
  include InstanceCounter
  attr_reader :stations

  def initialize(starting_station, end_station)
    @stations = [starting_station, end_station]
  end

  def add_station(way_station)
    stations.insert(-2, way_station)
  end

  def remove_station(way_station)
    stations.delete(way_station)
  end

  def show_stations
    stations.each do |station|
      puts station.name
    end
  end
end