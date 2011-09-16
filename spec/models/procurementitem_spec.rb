require 'spec_helper'

describe Procurementitem do
  it "should create a procurementitem given valid attributes" do
    FactoryGirl.build(:procurementitem).should be_valid
  end
  
  context "Validations - " do
    it "should require a isbn" do
      Procurementitem.new(FactoryGirl.attributes_for(:procurementitem).merge(:isbn => nil)).should_not be_valid
    end
  end
end
