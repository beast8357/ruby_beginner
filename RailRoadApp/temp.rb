station1 = Station.new("Los Santos")
station2 = Station.new("San Fierro")
station3 = Station.new("Las Venturas")
station4 = Station.new("Vice City")
station5 = Station.new("Liberty City")
station6 = Station.new("Carcer City")

route1 = Route.new(station1, station3)
route2 = Route.new(station6, station4)
route3 = Route.new(station4, station2)
route4 = Route.new(station3, station5)
route5 = Route.new(station5, station1)
route6 = Route.new(station2, station6)

train1 = Train.new("11WQ", "Cargo", 200)
train2 = Train.new("23DS", "Cargo", 200)
train3 = Train.new("31AX", "Cargo", 150)
train4 = Train.new("gt54", "Passenger", 50)
train5 = Train.new("hg33", "Passenger", 30)
train6 = Train.new("xd76", "Passenger", 30)

route1.add_station(station2)
route1.add_station(station5)
route1.add_station(station6)
route1.show_stations
train1.take_route(route1)
train1.go_to_next_station
train1.show_current_station
train1.go_to_next_station
train1.show_current_station
train1.go_to_next_station
train1.show_current_station
train1.go_to_previous_station
train1.show_current_station
train1.go_to_previous_station
train1.show_current_station
  


