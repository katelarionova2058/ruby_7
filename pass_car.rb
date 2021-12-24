class PassCar < Car
  def initialize(number, place_cnt)
    @number = number
    @type = :pass
    @init_place_cnt = place_cnt.to_i
    @place_cnt = place_cnt.to_i
    validate!
  end

  def filling_the_car
    place_cnt = place_cnt - 1 if place_cnt > 0
  end
  
  def engaged
    @init_place_cnt - @place_cnt
  end
end