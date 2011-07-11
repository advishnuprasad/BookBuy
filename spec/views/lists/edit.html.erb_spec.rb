require 'spec_helper'

describe "lists/edit.html.erb" do
  before(:each) do
    @list = assign(:list, stub_model(List,
      :name => "MyString",
      :type => "MyString",
      :key => 1,
      :pulled => "MyString",
      :created_by => 1,
      :modified_by => 1
    ))
  end

  it "renders the edit list form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => lists_path(@list), :method => "post" do
      assert_select "input#list_name", :name => "list[name]"
      assert_select "input#list_type", :name => "list[type]"
      assert_select "input#list_key", :name => "list[key]"
      assert_select "input#list_pulled", :name => "list[pulled]"
      assert_select "input#list_created_by", :name => "list[created_by]"
      assert_select "input#list_modified_by", :name => "list[modified_by]"
    end
  end
end