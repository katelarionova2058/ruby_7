class CargoTrain < Train
  def initialize (name)
    super
    @type = :cargo
  end
end
