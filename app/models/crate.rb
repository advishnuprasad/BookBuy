# == Schema Information
# Schema version: 20110417061158
#
# Table name: crates
#
#  id         :integer(38)     not null, primary key
#  po_no      :string(255)
#  invoice_no :string(255)
#  total_cnt  :integer(38)
#  created_at :datetime
#  updated_at :datetime
#

class Crate < ActiveRecord::Base
  CAPACITY    = 100;
  
  has_many :boxes
  
  after_create :generate_barcodes
  
  def formatted_po_name
    po_no[0..po_no.index('/',5)-1]
  end
  
  def formatted_po_file_name
    po_no[0..po_no.index('/',5)-1].gsub(/\//,'_')
  end
  
  def formatted_invoice_name
    invoice_no.gsub(/\//,'_')
  end
  
  def formatted_crate_file_name
    'CR_' + id.to_s
  end
  
  private 

    def generate_barcodes
      postr = formatted_po_name
      pofilename = formatted_po_file_name
      invstr = formatted_invoice_name
      
      pobarcode = Barby::Code128B.new(postr)
      invbarcode = Barby::Code128B.new(invoice_no)
      cratebarcode = Barby::Code128B.new(id)

      File.open('public/images/' + pofilename + '.png', 'wb') do |f|
        f.write pobarcode.to_png
      end
      File.open('public/images/' + invstr + '.png', 'wb') do |f|
        f.write invbarcode.to_png
      end
      File.open('public/images/' + formatted_crate_file_name + '.png', 'wb') do |f|
        f.write cratebarcode.to_png
      end
    end
end
