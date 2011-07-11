require 'spec_helper'

describe "imprints/index.html.erb" do
  before(:each) do
    assign(:imprints, [
      stub_model(Imprint,
        :code => "Code",
        :imprintname => "Imprintname",
        :group_id => 1,
        :publishername => "Publishername"
      ),
      stub_model(Imprint,
        :code => "Code",
        :imprintname => "Imprintname",
        :group_id => 1,
        :publishername => "Publishername"
      )
    ])
  end

  it "renders a list of imprints" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Imprintname".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Publishername".to_s, :count => 2
  end
end