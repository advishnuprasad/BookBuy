require 'spec_helper'

describe "listitems/new.html.erb" do
  before(:each) do
    assign(:listitem, stub_model(Listitem,
      :key => 1,
      :isbn => "MyString",
      :title => "MyString",
      :author => "MyString",
      :publisher => "MyString",
      :publisher_id => 1,
      :quantity => 1,
      :listprice => 1.5,
      :currency => "MyString",
      :category => "MyString",
      :subcategory => "MyString",
      :branch_id => 1,
      :created_by => 1,
      :modified_by => 1
    ).as_new_record)
  end

  it "renders new listitem form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => listitems_path, :method => "post" do
      assert_select "input#listitem_key", :name => "listitem[key]"
      assert_select "input#listitem_isbn", :name => "listitem[isbn]"
      assert_select "input#listitem_title", :name => "listitem[title]"
      assert_select "input#listitem_author", :name => "listitem[author]"
      assert_select "input#listitem_publisher", :name => "listitem[publisher]"
      assert_select "input#listitem_publisher_id", :name => "listitem[publisher_id]"
      assert_select "input#listitem_quantity", :name => "listitem[quantity]"
      assert_select "input#listitem_listprice", :name => "listitem[listprice]"
      assert_select "input#listitem_currency", :name => "listitem[currency]"
      assert_select "input#listitem_category", :name => "listitem[category]"
      assert_select "input#listitem_subcategory", :name => "listitem[subcategory]"
      assert_select "input#listitem_branch_id", :name => "listitem[branch_id]"
      assert_select "input#listitem_created_by", :name => "listitem[created_by]"
      assert_select "input#listitem_modified_by", :name => "listitem[modified_by]"
    end
  end
end
