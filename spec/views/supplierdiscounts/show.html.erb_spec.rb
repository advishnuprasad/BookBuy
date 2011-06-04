require 'spec_helper'

describe "supplierdiscounts/show.html.erb" do
  before(:each) do
    @supplierdiscount = assign(:supplierdiscount, stub_model(Supplierdiscount,
      :publisher_id => 1,
      :supplier_id => 1,
      :discount => 1.5,
      :bulkdiscount => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
  end
end
