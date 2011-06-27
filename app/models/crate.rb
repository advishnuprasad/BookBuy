# == Schema Information
# Schema version: 20110617100008
#
# Table name: crates
#
#  id          :integer(38)     not null, primary key
#  po_no       :string(255)
#  invoice_no  :string(255)
#  total_cnt   :integer(38)
#  created_at  :timestamp(6)
#  updated_at  :timestamp(6)
#  created_by  :integer(38)
#  modified_by :integer(38)
#

require 'barby'
require 'barby/outputter/png_outputter'

class Crate < ActiveRecord::Base
  CAPACITY    = 100;
  
  has_many :boxes
 
  after_create :generate_barcodes
  
  scope :recent, lambda {
    where('created_at >= ?',3.days.ago).
    order("id DESC")
  }

  def formatted_crate_file_name
    'CR_' + id.to_s
  end
  
  def fill
    boxes = Box.is_assigned(id)
    if boxes.count == 0
      Box.fill_crate(id)
    end
  end
  
  def regenerate
    generate_barcodes
  end
  
  private 

    def generate_barcodes
      cratebarcode = Barby::Code128B.new(id)

      File.open('public/images/' + formatted_crate_file_name + '.png', 'wb') do |f|
        f.write cratebarcode.to_png
      end
    end
end
