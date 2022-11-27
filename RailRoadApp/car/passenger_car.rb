class PassengerCar < Car
  attr_reader :type

  def initialize
    super(:passenger)
  end
end