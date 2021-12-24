module InstanceCounter
  attr_reader   :instances
  attr_accessor :instances

  def self.included(receiver)
    receiver.extend         ClassMethods 
    receiver.send :include, InstanceMethods 
  end

  module ClassMethods
    @instances = 0

    def instances_count
      @instances += 1
    end

    def instances
        @instances
    end
  end

  module InstanceMethods
    private
    
    def register_instance
      self.class.instances_count
    end
  end
end