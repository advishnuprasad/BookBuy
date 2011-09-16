require 'spec_helper'

describe Supplier do
  it "should create a supplier given valid attributes" do
    FactoryGirl.build(:supplier).should be_valid
  end
  
  context "Validations - " do
    it "should require a name" do
      Supplier.new(FactoryGirl.attributes_for(:supplier).merge(:name => nil)).should_not be_valid
    end
    
    it "should require a contact" do
      Supplier.new(FactoryGirl.attributes_for(:supplier).merge(:contact => nil)).should_not be_valid
    end
    
    it "should require a phone" do
      Supplier.new(FactoryGirl.attributes_for(:supplier).merge(:phone => nil)).should_not be_valid
    end
    
    it "should require a creditperiod" do
      Supplier.new(FactoryGirl.attributes_for(:supplier).merge(:creditperiod => nil)).should_not be_valid
    end
    
    it "should require a discount" do
      Supplier.new(FactoryGirl.attributes_for(:supplier).merge(:discount => nil)).should_not be_valid
    end
    
    it "should require a city" do
      Supplier.new(FactoryGirl.attributes_for(:supplier).merge(:city => nil)).should_not be_valid
    end
  end
end
