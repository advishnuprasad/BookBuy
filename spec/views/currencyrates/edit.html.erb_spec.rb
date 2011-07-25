require 'spec_helper'

describe "currencyrates/edit.html.erb" do
  before(:each) do
    @currencyrate = assign(:currencyrate, stub_model(Currencyrate,
      :code1 => "MyString",
      :code2 => "MyString",
      :rate => 1.5,
      :created_by => 1,
      :modified_by => 1
    ))
  end

  it "renders the edit currencyrate form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => currencyrates_path(@currencyrate), :method => "post" do
      assert_select "input#currencyrate_code1", :name => "currencyrate[code1]"
      assert_select "input#currencyrate_code2", :name => "currencyrate[code2]"
      assert_select "input#currencyrate_rate", :name => "currencyrate[rate]"
      assert_select "input#currencyrate_created_by", :name => "currencyrate[created_by]"
      assert_select "input#currencyrate_modified_by", :name => "currencyrate[modified_by]"
    end
  end
end
