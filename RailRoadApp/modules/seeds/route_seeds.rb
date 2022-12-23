module RouteSeeds
  def create_routes
    args = { starting_station: stations['s1'], end_station: stations['s2'] }
    routes['s1 - s2'] = Route.new(args)
    args = { starting_station: stations['s3'], end_station: stations['s4'] }
    routes['s3 - s4'] = Route.new(args)
    args = { starting_station: stations['s5'], end_station: stations['s6'] }
    routes['s5 - s6'] = Route.new(args)
  end

  def add_stations
    routes['s1 - s2'].add_station(stations['s3'])
    routes['s1 - s2'].add_station(stations['s4'])
    routes['s3 - s4'].add_station(stations['s5'])
    routes['s3 - s4'].add_station(stations['s6'])
    routes['s5 - s6'].add_station(stations['s1'])
    routes['s5 - s6'].add_station(stations['s2'])
  end
end
