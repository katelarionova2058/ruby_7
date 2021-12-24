require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'
require_relative 'validate.rb'
require_relative 'accessors.rb'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  extend Accessors
  
  NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/
  
  attr_reader :name, 
              :type, 
              :num , 
              :num_station , 
              :cars

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  attr_accessor_with_history :cars

  def initialize(name)
    @name  = name
    @type  = type  #в main делаю проверку поезда на тип, чтобы присоединить к нему вагон такого же типа, 
                   #если в родительском классе не будет этого типа, проверка сломается
    @cars  = []
    @trains = {}
    @speed = 0
    validate!
  end

  def stop
    @speed = 0
  end

  def self.find(num)
    @trains[num] #добавление в этот хеш в main в фунциях new_pass_trains и new_cargo_trains
  end

  def set_speed (value)
    @speed += value if value.positive?
  end

  def current_speed
    @speed 
  end

  def add_cars (car)
    @cars.push(car) if @speed.zero? && type = @type
  end

  def del_cars 
    @cars.delete_at(@cars.count - 1) if @speed.zero? 
  end

  def add_route(routes)
    @route = routes
    @current_station = @route.stations.first
    @current_station.add_trains(self)
  end

  def info_of_station_current 
    @current_station
  end

  def next
    self.info_of_station_next
    @current_station.del_trains(self)
    @next_station.add_trains(self)
    @current_station = @next_station
  end

  def back 
    self.info_of_station_back
    @current_station.del_trains(self)
    @back_station.add_trains(self)
    @current_station = @back_station
  end

  def each_cars(&block)
    raise "Вагоны в поезде #{name} отсутствуют." if @cars.empty?
    @cars.each { |car| block.call(car) } if block_given?
  end

  private

  def validate!
    raise "Номер не может отсутствовать" if name.nil?
    raise "Номер не соответствует формату" if name !~ NUMBER_FORMAT
    true
  end

  def info_of_station_back
    current_index = @route.stations.find_index(@current_station)
    @back_station = @route.stations[current_index -1] if (current_index - 1) >= 0
    @back_station
  end

  def info_of_station_next
    current_index = @route.stations.find_index(@current_station)
    @next_station = @route.stations[current_index +1] if (current_index +1) <= @route.stations.count
    @next_station
  end   
end 
