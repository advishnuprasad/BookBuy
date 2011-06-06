require "spec_helper"

describe ProcurementitemsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/procurementitems" }.should route_to(:controller => "procurementitems", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/procurementitems/new" }.should route_to(:controller => "procurementitems", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/procurementitems/1" }.should route_to(:controller => "procurementitems", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/procurementitems/1/edit" }.should route_to(:controller => "procurementitems", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/procurementitems" }.should route_to(:controller => "procurementitems", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/procurementitems/1" }.should route_to(:controller => "procurementitems", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/procurementitems/1" }.should route_to(:controller => "procurementitems", :action => "destroy", :id => "1")
    end

  end
end
