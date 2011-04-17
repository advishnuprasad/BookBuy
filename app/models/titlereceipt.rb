# == Schema Information
# Schema version: 20110416091241
#
# Table name: titlereceipts
#
#  id         :integer(38)     not null, primary key
#  po_no      :string(255)
#  invoice_no :string(255)
#  isbn       :string(255)
#  box_no     :integer(38)
#  created_at :datetime
#  updated_at :datetime
#

class Titlereceipt < ActiveRecord::Base
  before_validation :select_full_po_no
  before_create :upsert_box_total_cnt
  
  validates :po_no,             :presence => true
  validates :invoice_no,        :presence => true
  validates :isbn,              :presence => true
  validates :box_no,            :presence => true
  
  validate :po_no_should_exist
  validate :invoice_no_should_exist
  validate :isbn_should_be_part_of_po
  
  def po_no_should_exist
    unless po_no.blank?
      po = Po.find_by_code(po_no)
      if po.nil?
        errors.add(:po_no, " is invalid!")
      end
    end
  end
  
  def invoice_no_should_exist
    unless invoice_no.blank?
      invoice = Invoice.find_by_invoice_no(invoice_no)
      if invoice.nil?
        errors.add(:invoice_no, " is invalid!")
      end
    end
  end
  
  def isbn_should_be_part_of_po
    unless isbn.blank?
      item = Procurementitem.find_by_po_number_and_isbn(po_no, isbn)
      if item.nil?
        errors.add(:isbn, " is invalid!");
      end
    end
  end
  
  private
    
    def select_full_po_no
      if po_no.length == 9
        po_item = Po.where("code LIKE :po_no", {:po_no => "#{po_no}%"})
        self.po_no = po_item[0].code
      end
    end
    
    def upsert_box_total_cnt
      unless box_no.blank?
        box = Box.find_by_box_no(box_no)
        if box
          #Box Exists - Update total count
          #TODO - Put increment method within Box model
          box.total_cnt = box.total_cnt + 1
          box.save
        else
          #New Box - Create a new record
          #TODO - Directly pass params to Box New
          box = Box.new
          box.po_no = po_no
          box.invoice_no = invoice_no
          box.box_no = box_no
          box.total_cnt = 1
          box.save
        end
      end
    end
end
