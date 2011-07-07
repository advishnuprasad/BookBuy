require 'spec_helper'

describe "imprints/edit.html.erb" do
  before(:each) do
    @publisher = assign(:imprint, stub_model(Imprint,
      :code => "MyString",
      :imprintname => "MyString",
      :group_id => 1,
      :publishername => "MyString"
    ))
  end

  it "renders the edit imprint form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => imprints_path(@imprint), :method => "post" do
      assert_select "input#imprint_code", :name => "imprint[code]"
      assert_select "input#imprint_imprintname", :name => "imprint[imprintname]"
      assert_select "input#imprint_group_id", :name => "imprint[group_id]"
      assert_select "input#imprint_publishername", :name => "imprint[publishername]"
    end
  end
end
