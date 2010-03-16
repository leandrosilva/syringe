require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Syringe::Container do
  context 'when created' do
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
end
