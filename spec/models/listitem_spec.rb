require 'spec_helper'

describe Listitem do
  it "should create a listitem given valid attributes" do
    FactoryGirl.build(:listitem).should be_valid
  end
  
  context "validations - " do  
    it "should have a quantity" do
      Listitem.new(FactoryGirl.attributes_for(:listitem).merge(:quantity => nil)).should_not be_valid
    end
    
    it "should have a price" do
      Listitem.new(FactoryGirl.attributes_for(:listitem).merge(:listprice => nil)).should_not be_valid
    end
    
    it "should have a currency" do
      Listitem.new(FactoryGirl.attributes_for(:listitem).merge(:currency => nil)).should_not be_valid
    end
    
    it "should have a title" do
      Listitem.new(FactoryGirl.attributes_for(:listitem).merge(:title => nil)).should_not be_valid
    end
    
    it "should have an author" do
      Listitem.new(FactoryGirl.attributes_for(:listitem).merge(:author => nil)).should_not be_valid
    end
    
    it "should have a publisher" do
      Listitem.new(FactoryGirl.attributes_for(:listitem).merge(:publisher => nil)).should_not be_valid
    end
    
    it "should have a publisher id" do
      Listitem.new(FactoryGirl.attributes_for(:listitem).merge(:publisher_id => nil)).should_not be_valid
    end
  end
  
  context "should have a valid List item" do
    it "should save when List ID is valid" do
      list = FactoryGirl.create(:list)
      listitem = FactoryGirl.build(:listitem, :list_id => list.id)
      listitem.save.should == true
    end
    it "should not save when List ID does not exist" do
      listitem = FactoryGirl.build(:listitem, :list_id => -1)
      listitem.save.should == false
    end
  end
end
