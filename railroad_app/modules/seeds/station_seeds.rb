module StationSeeds
  def create_stations
    stations['s1'] = Station.new('s1')
    stations['s2'] = Station.new('s2')
    stations['s3'] = Station.new('s3')
    stations['s4'] = Station.new('s4')
    stations['s5'] = Station.new('s5')
    stations['s6'] = Station.new('s6')
  end
end
