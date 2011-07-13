require 'spec_helper'

describe "regionaltitles/new.html.erb" do
  before(:each) do
    assign(:regionaltitle, stub_model(Regionaltitle).as_new_record)
  end

  it "renders new regionaltitle form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => regionaltitles_path, :method => "post" do
    end
  end
end
