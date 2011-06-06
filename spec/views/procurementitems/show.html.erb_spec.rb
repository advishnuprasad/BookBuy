require 'spec_helper'

describe "procurementitems/show.html.erb" do
  before(:each) do
    @procurementitem = assign(:procurementitem, stub_model(Procurementitem,
      :isbn => "Isbn",
      :title => "Title",
      :author => "Author",
      :publisher => "Publisher",
      :supplier => "Supplier",
      :qty => 1,
      :branch => "Branch"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Isbn/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Author/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Publisher/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Supplier/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Branch/)
  end
end
