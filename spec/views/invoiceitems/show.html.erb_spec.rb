require 'spec_helper'

describe "invoiceitems/show.html.erb" do
  before(:each) do
    @invoiceitem = assign(:invoiceitem, stub_model(Invoiceitem))
  end

  it "renders attributes in <p>" do
    render
  end
end
