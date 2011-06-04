require 'spec_helper'

describe "supplierdiscounts/index.html.erb" do
  before(:each) do
    assign(:supplierdiscounts, [
      stub_model(Supplierdiscount,
        :publisher_id => 1,
        :supplier_id => 1,
        :discount => 1.5,
        :bulkdiscount => 1.5
      ),
      stub_model(Supplierdiscount,
        :publisher_id => 1,
        :supplier_id => 1,
        :discount => 1.5,
        :bulkdiscount => 1.5
      )
    ])
  end

  it "renders a list of supplierdiscounts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
