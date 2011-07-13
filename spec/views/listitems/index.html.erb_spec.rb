require 'spec_helper'

describe "listitems/index.html.erb" do
  before(:each) do
    assign(:listitems, [
      stub_model(Listitem,
        :key => 1,
        :isbn => "Isbn",
        :title => "Title",
        :author => "Author",
        :publisher => "Publisher",
        :publisher_id => 1,
        :quantity => 1,
        :listprice => 1.5,
        :currency => "Currency",
        :category => "Category",
        :subcategory => "Subcategory",
        :branch_id => 1,
        :created_by => 1,
        :modified_by => 1
      ),
      stub_model(Listitem,
        :key => 1,
        :isbn => "Isbn",
        :title => "Title",
        :author => "Author",
        :publisher => "Publisher",
        :publisher_id => 1,
        :quantity => 1,
        :listprice => 1.5,
        :currency => "Currency",
        :category => "Category",
        :subcategory => "Subcategory",
        :branch_id => 1,
        :created_by => 1,
        :modified_by => 1
      )
    ])
  end

  it "renders a listitem of listitems" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Isbn".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Author".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Publisher".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Currency".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Category".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Subcategory".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
