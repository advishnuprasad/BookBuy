require 'spec_helper'

describe "procurements/index.html.erb" do
  before(:each) do
    assign(:procurements, [
      stub_model(Procurement,
        :source_id => 1,
        :description => "Description",
        :requests_cnt => 1,
        :created_by => 1,
        :modified_by => 1
      ),
      stub_model(Procurement,
        :source_id => 1,
        :description => "Description",
        :requests_cnt => 1,
        :created_by => 1,
        :modified_by => 1
      )
    ])
  end

  it "renders a list of procurements" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end