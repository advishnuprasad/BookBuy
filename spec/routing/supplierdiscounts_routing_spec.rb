require "spec_helper"

describe SupplierdiscountsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/supplierdiscounts" }.should route_to(:controller => "supplierdiscounts", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/supplierdiscounts/new" }.should route_to(:controller => "supplierdiscounts", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/supplierdiscounts/1" }.should route_to(:controller => "supplierdiscounts", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/supplierdiscounts/1/edit" }.should route_to(:controller => "supplierdiscounts", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/supplierdiscounts" }.should route_to(:controller => "supplierdiscounts", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/supplierdiscounts/1" }.should route_to(:controller => "supplierdiscounts", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/supplierdiscounts/1" }.should route_to(:controller => "supplierdiscounts", :action => "destroy", :id => "1")
    end

  end
end
