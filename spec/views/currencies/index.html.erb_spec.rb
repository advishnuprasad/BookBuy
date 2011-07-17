require 'spec_helper'

describe "currencies/index.html.erb" do
  before(:each) do
    assign(:currencies, [
      stub_model(Currency,
        :name => "Name",
        :code => "Code",
        :created_by => 1,
        :modified_by => 1
      ),
      stub_model(Currency,
        :name => "Name",
        :code => "Code",
        :created_by => 1,
        :modified_by => 1
      )
    ])
  end

  it "renders a list of currencies" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
