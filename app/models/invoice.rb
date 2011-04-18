# == Schema Information
# Schema version: 20110416133936
#
# Table name: invoices
#
#  id              :integer(38)     not null, primary key
#  invoice_no      :string(255)
#  po_id           :integer(38)
#  date_of_receipt :datetime
#  quantity        :integer(38)
#  amount          :decimal(, )
#  created_at      :datetime
#  updated_at      :datetime
#  boxes_cnt       :integer(38)
#

require 'barby'
require 'barby/outputter/png_outputter'

class Invoice < ActiveRecord::Base
  belongs_to :po, :counter_cache => true
  after_create :generate_barcodes
  
  def formatted_po_name
    po.code[0..po.code.index('/',5)-1]
  end
  
  def formatted_po_file_name
    po.code[0..po.code.index('/',5)-1].gsub(/\//,'_')
  end
  
  def formatted_invoice_name
    invoice_no.gsub(/\//,'_')
  end
  
  def regenerate
    generate_barcodes
  end
  
  private 

    def generate_barcodes
      postr = formatted_po_name
      pofilename = formatted_po_file_name
      invstr = formatted_invoice_name
      
      pobarcode = Barby::Code128B.new(postr)
      invbarcode = Barby::Code128B.new(invoice_no)

      File.open('public/images/' + pofilename + '.png', 'wb') do |f|
        f.write pobarcode.to_png
      end
      File.open('public/images/' + invstr + '.png', 'wb') do |f|
        f.write invbarcode.to_png
      end
    end
  
end
