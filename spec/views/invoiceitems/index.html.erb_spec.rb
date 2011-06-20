require 'spec_helper'

describe "invoiceitems/index.html.erb" do
  before(:each) do
    assign(:invoiceitems, [
      stub_model(Invoiceitem),
      stub_model(Invoiceitem)
    ])
  end

  it "renders a list of invoiceitems" do
    render
  end
end
