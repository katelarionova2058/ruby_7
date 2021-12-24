require_relative 'instance_counter.rb'
require_relative 'validate.rb'

class Car
  include InstanceCounter
  include Validation

  attr_accessor :type,
                :number
  def initialize
    @type   = type
  end

  protected
  
  def validate!
    raise "Номер вагона не может быть пустым" if number.empty?
    raise "Номер вагона не может быть равен 0" if number == '0'
    true
  end
end