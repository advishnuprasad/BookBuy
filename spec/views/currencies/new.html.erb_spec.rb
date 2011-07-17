require 'spec_helper'

describe "currencies/new.html.erb" do
  before(:each) do
    assign(:currency, stub_model(Currency,
      :name => "MyString",
      :code => "MyString",
      :created_by => 1,
      :modified_by => 1
    ).as_new_record)
  end

  it "renders new currency form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => currencies_path, :method => "post" do
      assert_select "input#currency_name", :name => "currency[name]"
      assert_select "input#currency_code", :name => "currency[code]"
      assert_select "input#currency_created_by", :name => "currency[created_by]"
      assert_select "input#currency_modified_by", :name => "currency[modified_by]"
    end
  end
end
