class CargoCar < Car
  attr_reader :type

  def initialize
    @type = :cargo
  end
end