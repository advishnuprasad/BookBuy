require 'spec_helper'

describe "batches/new.html.erb" do
  before(:each) do
    assign(:batch, stub_model(Batch,
      :total_cnt => 1,
      :completed_cnt => 1
    ).as_new_record)
  end

  it "renders new batch form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => batches_path, :method => "post" do
      assert_select "input#batch_total_cnt", :name => "batch[total_cnt]"
      assert_select "input#batch_completed_cnt", :name => "batch[completed_cnt]"
    end
  end
end
