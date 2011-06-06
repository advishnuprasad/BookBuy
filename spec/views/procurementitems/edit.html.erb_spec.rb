require 'spec_helper'

describe "procurementitems/edit.html.erb" do
  before(:each) do
    @procurementitem = assign(:procurementitem, stub_model(Procurementitem,
      :isbn => "MyString",
      :title => "MyString",
      :author => "MyString",
      :publisher => "MyString",
      :supplier => "MyString",
      :qty => 1,
      :branch => "MyString"
    ))
  end

  it "renders the edit procurementitem form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => procurementitems_path(@procurementitem), :method => "post" do
      assert_select "input#procurementitem_isbn", :name => "procurementitem[isbn]"
      assert_select "input#procurementitem_title", :name => "procurementitem[title]"
      assert_select "input#procurementitem_author", :name => "procurementitem[author]"
      assert_select "input#procurementitem_publisher", :name => "procurementitem[publisher]"
      assert_select "input#procurementitem_supplier", :name => "procurementitem[supplier]"
      assert_select "input#procurementitem_qty", :name => "procurementitem[qty]"
      assert_select "input#procurementitem_branch", :name => "procurementitem[branch]"
    end
  end
end
