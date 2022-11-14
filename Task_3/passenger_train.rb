class PassengerTrain < Train
  def initialize(number)
    super(number)
    @type = :passenger
  end

  def add_car(car)
    super if car.type == :passenger
  end
end