require 'spec_helper'

describe "currencyrates/index.html.erb" do
  before(:each) do
    assign(:currencyrates, [
      stub_model(Currencyrate,
        :code1 => "Code1",
        :code2 => "Code2",
        :rate => 1.5,
        :created_by => 1,
        :modified_by => 1
      ),
      stub_model(Currencyrate,
        :code1 => "Code1",
        :code2 => "Code2",
        :rate => 1.5,
        :created_by => 1,
        :modified_by => 1
      )
    ])
  end

  it "renders a list of currencyrates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Code1".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Code2".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
