require 'spec_helper'

describe "publishers/index.html.erb" do
  before(:each) do
    assign(:publishers, [
      stub_model(Publisher,
        :name => "Name",
        :country => "Country"
      ),
      stub_model(Publisher,
        :name => "Name",
        :country => "Country"
      )
    ])
  end

  it "renders a list of publishers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Country".to_s, :count => 2
  end
end
