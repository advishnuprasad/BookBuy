require 'spec_helper'

describe "procurements/show.html.erb" do
  before(:each) do
    @procurement = assign(:procurement, stub_model(Procurement,
      :source_id => 1,
      :description => "Description",
      :requests_cnt => 1,
      :created_by => 1,
      :modified_by => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
