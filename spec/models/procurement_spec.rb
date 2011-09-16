require 'spec_helper'

describe Procurement do
  it "should create a procurement given valid attributes" do
    FactoryGirl.build(:procurement).should be_valid
  end
  
  context "Validations - " do
    it "should require a description" do
      Procurement.new(FactoryGirl.attributes_for(:procurement).merge(:description => nil)).should_not be_valid
    end
    
    it "should require a kind" do
      Procurement.new(FactoryGirl.attributes_for(:procurement).merge(:kind => nil)).should_not be_valid
    end

    it "should have a status" do
      Procurement.new(FactoryGirl.attributes_for(:procurement).merge(:status => nil)).should_not be_valid
    end
  end
  
  context "Pull - " do
    
  end
end
