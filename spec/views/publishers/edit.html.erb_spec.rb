require 'spec_helper'

describe "publishers/edit.html.erb" do
  before(:each) do
    @publisher = assign(:publisher, stub_model(Publisher,
      :name => "MyString",
      :country => "MyString"
    ))
  end

  it "renders the edit publisher form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => publishers_path(@publisher), :method => "post" do
      assert_select "input#publisher_name", :name => "publisher[name]"
      assert_select "input#publisher_country", :name => "publisher[country]"
    end
  end
end
