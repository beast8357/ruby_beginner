require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'

station1 = Station.new("Los Santos")
station2 = Station.new("San Fierro")
station3 = Station.new("Las Venturas")
station4 = Station.new("Vice City")
station5 = Station.new("Liberty City")
station6 = Station.new("Carcer City")
station7 = Station.new("Compton City")
station8 = Station.new("New Valley")
station9 = Station.new("Hill Valley")
station10 = Station.new("Nibba City")

route1 = Route.new(station1, station3)
route2 = Route.new(station10, station8)
route3 = Route.new(station1, station2)
route4 = Route.new(station3, station5)
route5 = Route.new(station6, station7)
route6 = Route.new(station2, station8)
route7 = Route.new(station9, station3)
route8 = Route.new(station10, station2)
route9 = Route.new(station8, station1)
route10 = Route.new(station2, station6)

train1 = Train.new("11WQ", "Cargo", 200)
train2 = Train.new("23DS", "Cargo", 200)
train3 = Train.new("31AX", "Cargo", 150)
train4 = Train.new("54SS", "Cargo", 150)
train5 = Train.new("33RT", "Cargo", 250)
train6 = Train.new("ad12", "Passenger", 50)
train7 = Train.new("sx23", "Passenger", 50)
train8 = Train.new("gt54", "Passenger", 50)
train9 = Train.new("hg33", "Passenger", 30)
train10 = Train.new("xd76", "Passenger", 30)

=begin
route1.add_station(station5)
route1.add_station(station7)
route1.add_station(station9)
route2.add_station(station6)
route2.add_station(station4)
route2.add_station(station2)
route3.add_station(station3)
route3.add_station(station4)
route3.add_station(station6)
route4.add_station(station6)
route4.add_station(station7)
route4.add_station(station10)
route5.add_station(station8)
route5.add_station(station9)
route5.add_station(station10)
=end






