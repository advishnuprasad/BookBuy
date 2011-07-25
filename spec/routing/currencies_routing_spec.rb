require "spec_helper"

describe CurrenciesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/currencies" }.should route_to(:controller => "currencies", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/currencies/new" }.should route_to(:controller => "currencies", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/currencies/1" }.should route_to(:controller => "currencies", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/currencies/1/edit" }.should route_to(:controller => "currencies", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/currencies" }.should route_to(:controller => "currencies", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/currencies/1" }.should route_to(:controller => "currencies", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/currencies/1" }.should route_to(:controller => "currencies", :action => "destroy", :id => "1")
    end

  end
end
