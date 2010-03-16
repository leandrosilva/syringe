require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Syringe::Container do
  context 'when instantiated' do
    subject do
      Syringe::Container.new
    end
    
    it 'should allow register and retrieve objects that can to be injected' do
      subject.register(:some_string) { |container| 'Some string' }
      subject[:some_string].should == 'Some string'
      subject.some_string.should == 'Some string'
      
      subject.register(:some_number) { |container| 1212 }
      subject[:some_number].should == 1212
      subject.some_number.should == 1212
    end
    
    it 'should raise error if a object already is registered' do
      subject.register(:some_string) { |container| 'Some string' }
      subject[:some_string].should == 'Some string'

      lambda {
        subject.register(:some_string) { |container| 'Some string' }
      }.should raise_error Syringe::DuplicateServiceError
    end
    
    it 'should raise error if a object was not registered' do
      lambda {
        subject[:some_string]
      }.should raise_error Syringe::MissingServiceError
    end
  end
  
  context 'when used as default container instance' do
    context 'and configured with registered objects' do
      it 'should be able to do dependency injection on classes' do
        default_container = Syringe::Container.default
        default_container.register(:service_uri) { |container| 'http://services.syringe.org/api' }
        
        service_consumer = SyringeHelperClasses::ServiceConsumer.new

        service_consumer.respond_to?(:service_uri).should == true
        service_consumer.service_uri.should == 'http://services.syringe.org/api'
      end
    end
  end
end
