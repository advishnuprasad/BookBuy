require "spec_helper"

describe CurrencyratesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/currencyrates" }.should route_to(:controller => "currencyrates", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/currencyrates/new" }.should route_to(:controller => "currencyrates", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/currencyrates/1" }.should route_to(:controller => "currencyrates", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/currencyrates/1/edit" }.should route_to(:controller => "currencyrates", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/currencyrates" }.should route_to(:controller => "currencyrates", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/currencyrates/1" }.should route_to(:controller => "currencyrates", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/currencyrates/1" }.should route_to(:controller => "currencyrates", :action => "destroy", :id => "1")
    end

  end
end
