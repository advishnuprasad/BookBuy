require 'spec_helper'

describe "publishers/edit.html.erb" do
  before(:each) do
    @publisher = assign(:publisher, stub_model(Publisher,
      :code => "MyString",
      :imprintname => "MyString",
      :group_id => 1,
      :publishername => "MyString"
    ))
  end

  it "renders the edit publisher form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => publishers_path(@publisher), :method => "post" do
      assert_select "input#publisher_code", :name => "publisher[code]"
      assert_select "input#publisher_imprintname", :name => "publisher[imprintname]"
      assert_select "input#publisher_group_id", :name => "publisher[group_id]"
      assert_select "input#publisher_publishername", :name => "publisher[publishername]"
    end
  end
end
