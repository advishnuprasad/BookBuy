require 'spec_helper'

describe "regionaltitles/show.html.erb" do
  before(:each) do
    @regionaltitle = assign(:regionaltitle, stub_model(Regionaltitle))
  end

  it "renders attributes in <p>" do
    render
  end
end
