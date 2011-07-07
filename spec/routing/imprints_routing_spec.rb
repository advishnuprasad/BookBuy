require "spec_helper"

describe ImprintsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/imprints" }.should route_to(:controller => "imprints", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/imprints/new" }.should route_to(:controller => "imprints", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/imprints/1" }.should route_to(:controller => "imprints", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/imprints/1/edit" }.should route_to(:controller => "imprints", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/imprints" }.should route_to(:controller => "imprints", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/imprints/1" }.should route_to(:controller => "imprints", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/imprints/1" }.should route_to(:controller => "imprints", :action => "destroy", :id => "1")
    end

  end
end
