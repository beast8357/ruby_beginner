module Seeds
  def load_seeds
    stations["s1"] = Station.new("s1")
    stations["s2"] = Station.new("s2")
    stations["s3"] = Station.new("s3")
    stations["s4"] = Station.new("s4")
    stations["s5"] = Station.new("s5")
    stations["s6"] = Station.new("s6")

    routes["s1 - s2"] = Route.new(stations["s1"], stations["s2"])
    routes["s3 - s4"] = Route.new(stations["s3"], stations["s4"])
    routes["s5 - s6"] = Route.new(stations["s5"], stations["s6"])

    routes["s1 - s2"].add_station(stations["s3"])
    routes["s1 - s2"].add_station(stations["s4"])
    routes["s3 - s4"].add_station(stations["s5"])
    routes["s3 - s4"].add_station(stations["s6"])
    routes["s5 - s6"].add_station(stations["s1"])
    routes["s5 - s6"].add_station(stations["s2"])

    trains["P00-01"] = PassengerTrain.new("P00-01")
    trains["P00-02"] = PassengerTrain.new("P00-02")
    trains["P00-03"] = PassengerTrain.new("P00-03")
    trains["C00-01"] = CargoTrain.new("C00-01")
    trains["C00-02"] = CargoTrain.new("C00-02")
    trains["C00-03"] = CargoTrain.new("C00-03")

    10.times { trains["P00-01"].add_car(PassengerCar.new(100)) }
    20.times { trains["P00-02"].add_car(PassengerCar.new(200)) }
    30.times { trains["P00-03"].add_car(PassengerCar.new(300)) }
    10.times { trains["C00-01"].add_car(CargoCar.new(1000)) }
    20.times { trains["C00-02"].add_car(CargoCar.new(2000)) }
    30.times { trains["C00-03"].add_car(CargoCar.new(3000)) }

    trains["P00-01"].take_route(routes["s1 - s2"])
    trains["P00-02"].take_route(routes["s1 - s2"])
    trains["P00-03"].take_route(routes["s3 - s4"])
    trains["C00-01"].take_route(routes["s3 - s4"])
    trains["C00-02"].take_route(routes["s5 - s6"])
    trains["C00-03"].take_route(routes["s5 - s6"])
  end
end