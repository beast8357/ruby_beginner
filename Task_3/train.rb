class Train
  attr_accessor :speed, :cars
  attr_reader :number, :type

  def initialize(number = "unknown", type = "undefined", cars = 0)
    @number = number
    @type = type.downcase.capitalize
    @cars = cars
    @speed = 0
  end

  def gain_speed
    self.speed += 10
    puts "Speed increased by 10."
  end

  def show_speed
    puts "Current speed: #{self.speed}."
  end

  def brake
    if self.speed > 0
      self.speed -= 10
      puts "Speed decreased by 10." if self.speed != 0
      puts "The train stopped." if self.speed == 0
    end
  end

  def show_cars
    puts "Current cars number: #{self.cars}."
  end

  def remove_car
    if self.speed == 0
      if self.cars > 0
        self.cars -= 1
        puts "Car removed."
      else
        puts "Can't perform the action: The number of cars should be greated than 0."
      end
    else
      puts "The train must stop in order to remove a car."
    end
  end

  def add_car
    if self.speed == 0
      self.cars += 1
      puts "Car added."
    else
      puts "The train must stop in order to add a car."
    end
  end
end