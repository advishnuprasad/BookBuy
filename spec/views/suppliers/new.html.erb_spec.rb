require 'spec_helper'

describe "suppliers/new.html.erb" do
  before(:each) do
    assign(:supplier, stub_model(Supplier,
      :name => "MyString",
      :contact => "MyString",
      :phone => "MyString",
      :city => "MyString",
      :typeofshipping => 1,
      :discount => 1.5,
      :creditperiod => 1
    ).as_new_record)
  end

  it "renders new supplier form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => suppliers_path, :method => "post" do
      assert_select "input#supplier_name", :name => "supplier[name]"
      assert_select "input#supplier_contact", :name => "supplier[contact]"
      assert_select "input#supplier_phone", :name => "supplier[phone]"
      assert_select "input#supplier_city", :name => "supplier[city]"
      assert_select "input#supplier_typeofshipping", :name => "supplier[typeofshipping]"
      assert_select "input#supplier_discount", :name => "supplier[discount]"
      assert_select "input#supplier_creditperiod", :name => "supplier[creditperiod]"
    end
  end
end
