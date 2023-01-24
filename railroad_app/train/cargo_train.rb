class CargoTrain < Train
  def initialize(number)
    super(number: number, type: :cargo)
  end
end
