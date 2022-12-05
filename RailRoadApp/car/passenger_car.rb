class PassengerCar < Car
  
  def initialize(seats)
    super(:passenger, seats, nil)
  end

  def take_seats(value)
    raise "Your value is too big!" if value > free_seats
    self.taken_seats += value
  end
end