#
# Extension for Object to provide dependency injection capability.
#
class Object
  # Define a new method and instance variable named as +object_name+ parameter.
  def self.inject(object_name)
    instance_eval do
      send(:define_method, object_name) do
        instance_variable_set("@#{object_name}", Syringe::Container.default[object_name])
      end
    end
  end
end