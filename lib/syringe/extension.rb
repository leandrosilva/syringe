#
# Extension for Object to provide dependency injection capability.
#
class Object
  def self.inject(object_name)
    instance_eval do
      send(:define_method, object_name) do
        Syringe::Container.default[object_name]
      end
    end
  end
end