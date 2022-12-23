module CarSeeds
  def add_cars
    2.times { trains['P00-01'].add_car(PassengerCar.new(100)) }
    4.times { trains['P00-02'].add_car(PassengerCar.new(200)) }
    6.times { trains['P00-03'].add_car(PassengerCar.new(300)) }
    2.times { trains['C00-01'].add_car(CargoCar.new(1000)) }
    4.times { trains['C00-02'].add_car(CargoCar.new(2000)) }
    6.times { trains['C00-03'].add_car(CargoCar.new(3000)) }
  end
end
