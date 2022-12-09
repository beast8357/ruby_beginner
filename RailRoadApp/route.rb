require_relative "modules/instance_counter"

class Route
  include InstanceCounter
  attr_reader :stations

  def initialize(starting_station, end_station)
    @stations = [starting_station, end_station]
    validate!
    register_instance
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

  def each_station(&block)
    raise "No block given." unless block_given?
    stations.each.with_index(1) { |station, index| block.call(station, index) }
  end

  private
  
  def validate!
    raise "At least 2 stations required." if stations.size < 2
  end
end