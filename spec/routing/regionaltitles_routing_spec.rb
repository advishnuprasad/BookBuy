require "spec_helper"

describe RegionaltitlesController do
  describe "routing" do

    it "routes to #index" do
      get("/regionaltitles").should route_to("regionaltitles#index")
    end

    it "routes to #new" do
      get("/regionaltitles/new").should route_to("regionaltitles#new")
    end

    it "routes to #show" do
      get("/regionaltitles/1").should route_to("regionaltitles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/regionaltitles/1/edit").should route_to("regionaltitles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/regionaltitles").should route_to("regionaltitles#create")
    end

    it "routes to #update" do
      put("/regionaltitles/1").should route_to("regionaltitles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/regionaltitles/1").should route_to("regionaltitles#destroy", :id => "1")
    end

  end
end
