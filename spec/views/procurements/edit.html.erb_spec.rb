require 'spec_helper'

describe "procurements/edit.html.erb" do
  before(:each) do
    @procurement = assign(:procurement, stub_model(Procurement,
      :source_id => 1,
      :description => "MyString",
      :requests_cnt => 1,
      :created_by => 1,
      :modified_by => 1
    ))
  end

  it "renders the edit procurement form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => procurements_path(@procurement), :method => "post" do
      assert_select "input#procurement_source_id", :name => "procurement[source_id]"
      assert_select "input#procurement_description", :name => "procurement[description]"
      assert_select "input#procurement_requests_cnt", :name => "procurement[requests_cnt]"
      assert_select "input#procurement_created_by", :name => "procurement[created_by]"
      assert_select "input#procurement_modified_by", :name => "procurement[modified_by]"
    end
  end
end
