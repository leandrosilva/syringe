#
# Syringe Dependency Injection Container
#
# This code is strongly based (almost entirely a copy) on Jim Weirich's sample code at:
# http://onestepback.org/index.cgi/Tech/Ruby/DependencyInjectionInRuby.rdoc
#
# One more time: thanks Jim!
#
module Syringe
  #
  # Thrown when a service cannot be located by name.
  #
  class MissingServiceError < StandardError; end

  #
  # Thrown when a duplicate service is registered.
  #
  class DuplicateServiceError < StandardError; end

  #
  # Syringe::Container is the central data store for registering services used for dependency injuction.
  # Users register services by providing a name and a block used to create the service. Services may be
  # retrieved by asking for them by name (via the [] operator) or by selector (via the method_missing
  # technique).
  #
  class Container
    @@default_container = nil
    
    #
    # Get default container. It's fundamentaly useful for "inject" class method added to Object class.
    #
    def self.default
      @@default_container ||= Container.new
    end

    # Create a dependency injection container.
    def initialize
      @services = {}
      @cache = {}
    end

    # Register a service named +name+. The +block+ will be used to create the service on demand. It is
    # recommended that symbols be used as the name of a service.
    def register(name, &block)
      raise DuplicateServiceError, "Duplicate Service Name '#{name}'" if @services.include? name
      
      @services[name] = block
    end

    # Lookup a service by name. Throw an exception if no service is found.
    def [](name)
      @cache[name] ||= service_block(name).call(self)
    end

    # Lookup a service by message selector. A service with the same name as +sym+ will be returned, or
    # an exception is thrown if no matching service is found.
    def method_missing(sym, *args, &block)
      self[sym]
    end

    private

      # Return the block that creates the named service. Throw an exception if no service creation block of
      # the given name can be found in the container or its parents.
      def service_block(name)
        raise MissingServiceError, "Unknown Service '#{name}'" unless @services.include? name
      
        @services[name]
      end
  end
end