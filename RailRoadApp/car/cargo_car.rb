class CargoCar < Car
  attr_reader :type

  def initialize
    super(:cargo)
  end
end