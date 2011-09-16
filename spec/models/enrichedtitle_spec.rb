require 'spec_helper'

describe Enrichedtitle do
  it "should create a enrichedtitle given valid attributes" do
    FactoryGirl.build(:enrichedtitle).should be_valid
  end
  
  context "Validations - " do
    it "should require a title" do
      Enrichedtitle.new(FactoryGirl.attributes_for(:enrichedtitle).merge(:title => nil)).should_not be_valid
    end
    
    it "should require an ISBN" do
      Enrichedtitle.new(FactoryGirl.attributes_for(:enrichedtitle).merge(:isbn => nil)).should_not be_valid
    end

    it "should require an author" do
      Enrichedtitle.new(FactoryGirl.attributes_for(:enrichedtitle).merge(:author => nil)).should_not be_valid
    end
    
    it "should require a listprice" do
      Enrichedtitle.new(FactoryGirl.attributes_for(:enrichedtitle).merge(:listprice => nil)).should_not be_valid
    end
    
    it "should require a currency" do
      Enrichedtitle.new(FactoryGirl.attributes_for(:enrichedtitle).merge(:currency => nil)).should_not be_valid
    end
  end
end
