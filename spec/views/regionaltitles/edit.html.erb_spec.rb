require 'spec_helper'

describe "regionaltitles/edit.html.erb" do
  before(:each) do
    @regionaltitle = assign(:regionaltitle, stub_model(Regionaltitle))
  end

  it "renders the edit regionaltitle form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => regionaltitles_path(@regionaltitle), :method => "post" do
    end
  end
end
