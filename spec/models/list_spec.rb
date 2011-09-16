require 'spec_helper'

describe List do
  it "should create a list given valid attributes" do
    FactoryGirl.build(:list).should be_valid
  end
  
  context "Validations - " do
    it "should have a name" do
      List.new(FactoryGirl.attributes_for(:list).merge(:name => '')).should_not be_valid
    end
    
    it "should have a description" do
      List.new(FactoryGirl.attributes_for(:list).merge(:description => nil)).should_not be_valid
    end
  end
end
