require 'spec_helper'

describe "currencyrates/show.html.erb" do
  before(:each) do
    @currencyrate = assign(:currencyrate, stub_model(Currencyrate,
      :code1 => "Code1",
      :code2 => "Code2",
      :rate => 1.5,
      :created_by => 1,
      :modified_by => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Code1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Code2/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
