require 'spec_helper'

describe "invoiceitems/edit.html.erb" do
  before(:each) do
    @invoiceitem = assign(:invoiceitem, stub_model(Invoiceitem))
  end

  it "renders the edit invoiceitem form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => invoiceitems_path(@invoiceitem), :method => "post" do
    end
  end
end
