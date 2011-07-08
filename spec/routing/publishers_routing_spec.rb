require "spec_helper"

describe PublishersController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/publishers" }.should route_to(:controller => "publishers", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/publishers/new" }.should route_to(:controller => "publishers", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/publishers/1" }.should route_to(:controller => "publishers", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/publishers/1/edit" }.should route_to(:controller => "publishers", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/publishers" }.should route_to(:controller => "publishers", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/publishers/1" }.should route_to(:controller => "publishers", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/publishers/1" }.should route_to(:controller => "publishers", :action => "destroy", :id => "1")
    end

  end
end
