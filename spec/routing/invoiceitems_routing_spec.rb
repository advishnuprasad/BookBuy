require "spec_helper"

describe InvoiceitemsController do
  describe "routing" do

    it "routes to #index" do
      get("/invoiceitems").should route_to("invoiceitems#index")
    end

    it "routes to #new" do
      get("/invoiceitems/new").should route_to("invoiceitems#new")
    end

    it "routes to #show" do
      get("/invoiceitems/1").should route_to("invoiceitems#show", :id => "1")
    end

    it "routes to #edit" do
      get("/invoiceitems/1/edit").should route_to("invoiceitems#edit", :id => "1")
    end

    it "routes to #create" do
      post("/invoiceitems").should route_to("invoiceitems#create")
    end

    it "routes to #update" do
      put("/invoiceitems/1").should route_to("invoiceitems#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/invoiceitems/1").should route_to("invoiceitems#destroy", :id => "1")
    end

  end
end
