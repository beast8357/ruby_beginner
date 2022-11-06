class Route 
  attr_reader :stations

  def initialize(starting_station, end_station)
    @stations = [starting_station, end_station]
  end

  def add_station(way_station)
    @stations.insert(-2, way_station)
    puts "Added way station #{way_station.name}."
  end

  def remove_station(way_station)
    @stations.delete(way_station)
    puts "Removed way station #{way_station.name}."
  end

  def show_stations
    @stations.each do |station|
      puts station.name
    end
  end
end