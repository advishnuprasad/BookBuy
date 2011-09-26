require 'spec_helper'

describe "batches/index.html.erb" do
  before(:each) do
    assign(:batches, [
      stub_model(Batch,
        :total_cnt => 1,
        :completed_cnt => 1
      ),
      stub_model(Batch,
        :total_cnt => 1,
        :completed_cnt => 1
      )
    ])
  end

  it "renders a list of batches" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
