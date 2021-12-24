require_relative 'train'
require_relative 'car'
require_relative 'pass_train'
require_relative 'cargo_train'
require_relative 'pass_car'
require_relative 'cargo_car'
require_relative 'station'
require_relative 'route'

class Controller

  def menu
    puts "Меню:"
    puts "1 - Создать станцию"
    puts "2 - Создать поезд"
    puts "3 - Создать маршрут"
    puts "4 - Изменить маршрут"
    puts "5 - Назначить поезду маршрут"
    puts "6 - Изменить состав поезда"
    puts "7 - Переместить поезд"
    puts "8 - Информация"
    puts "9 - Занять место"
  end

  attr_reader :stations,
              :trains,
              :routes

  def initialize  
    @stations = []
    @trains   = []
    @routes   = []
    loop do
      menu
      run
    end
  end

  def run
    puts "Что вы хотите сделать?"
    action = gets.chomp
    case action
      when "1"
        new_station
      when "2"
        new_train
      when "3"
        new_route
      when "4"
        change_route
      when "5"
        train_to_roat
      when "6"
        railway_train
      when "7"
        moving
      when "8"
        info
      when "9"
        filling
      else
        exit
    end
  end

  private

  def new_station
    begin
      puts "Укажите Наименование станции"
      name = gets.chomp
      @station = Station.new(name)
    rescue RuntimeError => e
      puts e
      puts "Попробуй заново"
      retry 
    end
    @stations.push(@station)
    puts "Создана станция #{name}"
    return @station
   end

  def new_pass_trains
    begin
      puts "Укажите Наименование поезда"
      name = gets.chomp
      @new_train = PassTrain.new(name)
    rescue RuntimeError => e
      puts e
      puts "Попробуй заново"
      retry 
    end
    designate_manufacturer
    @trains.push(@new_train)
    puts "Создан поезд #{name} от производителя #{@new_train.fabrica}"
  end

  def new_cargo_trains
    begin
      puts "Укажите Наименование поезда"
      name = gets.chomp
      @new_train = CargoTrain.new(name)
    rescue RuntimeError => e
      puts e
      puts "Попробуй заново"
      retry 
    end
    designate_manufacturer
    @trains.push(@new_train)
    puts "Создан поезд #{name} от производителя #{@new_train.fabrica}"
  end

  def new_route
    puts "Укажите название маршрута"
    name_route  = gets.chomp
    puts "Начальная станция:"
    st_first = new_station
    puts "Конечная станция"
    st_last = new_station
    @route = Route.new st_first , st_last, name_route
    @routes.push(@route)
  end

  def add_station_in_route
    puts "Укажите название маршрута"
    route_get  = gets.chomp  
    search_of_route = @routes.bsearch { |route| route.name_route == route_get }
    new_station
    search_of_route.add_station @station
  end

  def del_station_in_route
    puts "Укажите название маршрута"
    route_get  = gets.chomp
    search_of_route = @routes.bsearch { |route| route.name_route == route_get }
    station_get  = gets.chomp
    search_of_route.del_stations (station_get)
  end

  def train_to_roat
    puts "Укажите название поезда"
    train_get  = gets.chomp
    search_of_train = @trains.bsearch { |train| train.name == train_get }
    puts "Укажите название маршрута"
    route_get  = gets.chomp
    search_of_route = @routes.bsearch { |route| route.name_route == route_get }
    search_of_train.add_route search_of_route
    search_of_route.stations.first.show_trains
  end

  def move_to_back
    puts "Укажите название поезда"
    train_get  = gets.chomp
    search_of_train = @trains.bsearch { |train| train.name == train_get }
    search_of_train.back
  end

  def move_to_forward
    puts "Укажите название поезда"
    train_get  = gets.chomp
    search_of_train = @trains.bsearch { |train| train.name == train_get }
    search_of_train.next
  end

  def add_car
    puts "Укажите название поезда"
    train_get  = gets.chomp
    search_of_train = @trains.bsearch { |train| train.name == train_get }
    begin
      puts "Укажите номер вагона"
      car_number = gets.chomp
      type_tr = search_of_train.type.to_s
      if type_tr == "pass" 
        puts "Укажите количество мест в вагоне"
        cnt_pls = gets.chomp
        car = PassCar.new car_number, cnt_pls
      elsif type_tr == "cargo" 
        puts "Укажите объем вагона"
        vol = gets.chomp
        car = CargoCar.new car_number, vol
      end
    rescue RuntimeError => e
      puts e
      puts "Попробуй заново"
      retry 
    end
    car.type = search_of_train.type
    search_of_train.add_cars(car)
  end

  def del_car
    puts "Укажите название поезда"
    train_get  = gets.chomp
    search_of_train = @trains.bsearch { |train| train.name == train_get }
    search_of_train.del_cars
  end

  def show_stations
    @stations.each { |station| puts station.class}
  end

  def new_train
    puts "Выберите тип поезда"
    puts "1 - грузовой "
    puts "2 - пассажирский"
    action_newtrain = gets.chomp
    case action_newtrain
      when "1"
        new_cargo_trains
      when "2"
        new_pass_trains 
    end
  end

  def change_route
    puts "1 - Добавить станцию"
    puts "2 - Удалить станцию"
    action_route = gets.chomp
    case action_route
      when "1"
        add_station_in_route
      when "2"
        del_station_in_route  
    end
  end

  def railway_train
    puts "1 - добавить вагон"
    puts "2 - удалить вагон"
    action_train = gets.chomp
    case action_train
      when "1"
        add_car
      when "2"
       del_car
    end
  end

  def moving
    puts "1 - Переместить назад"
    puts "2 - Переместить вперед"
    action_move = gets.chomp
    case action_move
      when "1"
        move_to_back
      when "2"
        move_to_forward
    end
  end

  def info
    puts "1 - Список станций"
    puts "2 - Список поездов на станции"
    puts "3 - Производитель поезда"
    puts "4 - Список вагонов поезда"
    action_info = gets.chomp
    case action_info
      when "1"
        show_stations
      when "2"
        show_trains_on_st
      when "3"
        info_manufacturer
      when "4"
        show_cars_on_tr
    end
  end

  def designate_manufacturer
    puts "Укажите производителя поезда"
    manfact = gets.chomp
    @new_train.fabricator(manfact)
  end  

  def info_manufacturer
    puts "Укажите номер поезда"
    train_get = gets.chomp
    search_train = @trains.bsearch { |train| train.name == train_get }
    puts search_train.fabrica
  end

  def filling
    puts "Укажите название поезда"
    train_get  = gets.chomp
    puts "Укажите номер вагона"
    car_get  = gets.chomp
    search_of_train = @trains.bsearch { |train| train.name == train_get}
    search_of_num = search_of_train.cars.bsearch { |car| car.number == car_get }
    if search_of_num.type.to_s == "pass"
      search_of_num.filling_the_car
    elsif search_of_num.type.to_s == "cargo"
      puts "Введите объем"
      vol = gets.chomp.to_i
      search_of_num.filling_the_car vol
    end
  end

  def show_trains_on_st
    if @stations.empty?
      puts 'Не создано ни одной станции'
    else
      puts 'Укажите название станции'
      get_st = gets.chomp
      station = @stations.find { |station| station.name == get_st }
      station.each_train { |train| print "Название: ", train.name, " Тип: ", train.type, " Производитель: ", train.fabrica, "\n" }
    end
  end

  def show_cars_on_tr
    if @trains.empty?
      puts 'Не создано ни одного поезда'
    else
      puts 'Укажите название поезда'
      get_tr = gets.chomp
      train = @trains.find { |train| train.name == get_tr }
      train.each_cars { |car| print "Номер: ", car.number, " Тип: ", car.type,  "\n" }
    end
  end
end

control =Controller.new
