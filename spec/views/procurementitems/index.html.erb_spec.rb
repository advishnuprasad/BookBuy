require 'spec_helper'

describe "procurementitems/index.html.erb" do
  before(:each) do
    assign(:procurementitems, [
      stub_model(Procurementitem,
        :isbn => "Isbn",
        :title => "Title",
        :author => "Author",
        :publisher => "Publisher",
        :supplier => "Supplier",
        :qty => 1,
        :branch => "Branch"
      ),
      stub_model(Procurementitem,
        :isbn => "Isbn",
        :title => "Title",
        :author => "Author",
        :publisher => "Publisher",
        :supplier => "Supplier",
        :qty => 1,
        :branch => "Branch"
      )
    ])
  end

  it "renders a list of procurementitems" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Isbn".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Author".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Publisher".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Supplier".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Branch".to_s, :count => 2
  end
end
