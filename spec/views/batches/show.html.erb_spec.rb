require 'spec_helper'

describe "batches/show.html.erb" do
  before(:each) do
    @batch = assign(:batch, stub_model(Batch,
      :total_cnt => 1,
      :completed_cnt => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
