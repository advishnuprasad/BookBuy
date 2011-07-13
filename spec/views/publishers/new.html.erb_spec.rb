require 'spec_helper'

describe "publishers/new.html.erb" do
  before(:each) do
    assign(:publisher, stub_model(Publisher,
      :name => "MyString",
      :country => "MyString"
    ).as_new_record)
  end

  it "renders new publisher form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => publishers_path, :method => "post" do
      assert_select "input#publisher_name", :name => "publisher[name]"
      assert_select "input#publisher_country", :name => "publisher[country]"
    end
  end
end
