require 'spec_helper'

describe "regionaltitles/index.html.erb" do
  before(:each) do
    assign(:regionaltitles, [
      stub_model(Regionaltitle),
      stub_model(Regionaltitle)
    ])
  end

  it "renders a list of regionaltitles" do
    render
  end
end
