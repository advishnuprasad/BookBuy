require 'spec_helper'

describe "invoiceitems/new.html.erb" do
  before(:each) do
    assign(:invoiceitem, stub_model(Invoiceitem).as_new_record)
  end

  it "renders new invoiceitem form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => invoiceitems_path, :method => "post" do
    end
  end
end
