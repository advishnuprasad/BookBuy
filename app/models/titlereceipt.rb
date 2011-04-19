# == Schema Information
# Schema version: 20110419045025
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
#  book_no    :string(255)
#

class Titlereceipt < ActiveRecord::Base
  before_validation :select_full_po_no
  before_create :upsert_box_total_cnt
  
  scope :of_po, lambda { |po_no, isbn|
      where("po_no = :po_no AND isbn = :isbn", {:po_no => po_no, :isbn => isbn}).
      order("created_at").
      limit(1)
    }  
  scope :not_cataloged, where("book_no IS NULL")
  
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
        puts po_item.to_s
        if po_item
          self.po_no = po_item[0].code
        end
      end
    end
    
    def upsert_box_total_cnt
      unless box_no.blank?
        box = Box.find_by_box_no_and_po_no_and_invoice_no(box_no, po_no, invoice_no)
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
