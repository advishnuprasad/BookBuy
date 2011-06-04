require 'spec_helper'

describe "supplierdiscounts/new.html.erb" do
  before(:each) do
    assign(:supplierdiscount, stub_model(Supplierdiscount,
      :publisher_id => 1,
      :supplier_id => 1,
      :discount => 1.5,
      :bulkdiscount => 1.5
    ).as_new_record)
  end

  it "renders new supplierdiscount form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => supplierdiscounts_path, :method => "post" do
      assert_select "input#supplierdiscount_publisher_id", :name => "supplierdiscount[publisher_id]"
      assert_select "input#supplierdiscount_supplier_id", :name => "supplierdiscount[supplier_id]"
      assert_select "input#supplierdiscount_discount", :name => "supplierdiscount[discount]"
      assert_select "input#supplierdiscount_bulkdiscount", :name => "supplierdiscount[bulkdiscount]"
    end
  end
end
