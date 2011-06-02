require "spec_helper"

describe ProcurementsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/procurements" }.should route_to(:controller => "procurements", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/procurements/new" }.should route_to(:controller => "procurements", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/procurements/1" }.should route_to(:controller => "procurements", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/procurements/1/edit" }.should route_to(:controller => "procurements", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/procurements" }.should route_to(:controller => "procurements", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/procurements/1" }.should route_to(:controller => "procurements", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/procurements/1" }.should route_to(:controller => "procurements", :action => "destroy", :id => "1")
    end

  end
end
