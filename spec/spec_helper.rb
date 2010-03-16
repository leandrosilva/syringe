$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'syringe'
require 'spec'

module SyringeHelperClasses
  class ServiceConsumer
    inject :service_uri
  end
end