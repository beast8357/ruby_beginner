class Route
  attr_accessor :stations
  attr_reader :start_station, :end_station

  def initialize(start_station = "Start station", end_station = "End station")
    @start_station = start_station
    @end_station = end_station
    @stations = [start_station, end_station]
  end

  def add_station(way_station)
    stations.insert(-2, way_station)
    puts "Added way station #{way_station}."
  end

  def remove_station(way_station)
    stations.delete(way_station)
    puts "Removed way station #{way_station}."
  end

  def show_stations
    stations.each do |station|
      puts station
    end
  end
end