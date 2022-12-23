module TrainSeeds
  def create_trains
    trains['P00-01'] = PassengerTrain.new('P00-01')
    trains['P00-02'] = PassengerTrain.new('P00-02')
    trains['P00-03'] = PassengerTrain.new('P00-03')
    trains['C00-01'] = CargoTrain.new('C00-01')
    trains['C00-02'] = CargoTrain.new('C00-02')
    trains['C00-03'] = CargoTrain.new('C00-03')
  end
end
