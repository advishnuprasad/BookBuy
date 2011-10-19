# == Schema Information
# Schema version: 20110630044015
#
# Table name: titlereceipts
#
#  id         :integer(38)     not null, primary key
#  po_no      :string(255)     not null
#  invoice_no :string(255)     not null
#  isbn       :string(255)     not null
#  box_no     :integer(38)     not null
#  created_at :timestamp(6)
#  updated_at :timestamp(6)
#  book_no    :string(1020)
#  created_by :integer(38)
#  error      :string(1020)
#

class Titlereceipt < ActiveRecord::Base
  
  scope :valid, where("error is NULL")

  scope :of_po_and_isbn, lambda { |po_no, isbn|
      valid.
      where("po_no = :po_no AND isbn = :isbn", {:po_no => po_no, :isbn => isbn}).
      order("created_at")
    }

  scope :of_po_inv_box_and_isbn, lambda { |po_no, inv_no, box_no, isbn|
      valid.
      where("po_no = :po_no AND isbn = :isbn AND invoice_no = :inv_no AND box_no = :box_no AND book_no IS NULL AND error is NULL", {:po_no => po_no, :isbn => isbn, :inv_no => inv_no, :box_no => box_no}).
      order("created_at")
  }

  scope :of_invoice, lambda{|invoice_no|
      valid.
      where(:invoice_no => invoice_no).
      order("created_at")
    }
  scope :not_cataloged, lambda{
      valid.
      where("book_no IS NULL")
    }
  scope :of_po, lambda { |po_no|
      valid.
      where(:po_no => po_no)
    }
  
  validates :po_no,             :presence => true
  validates :invoice_no,        :presence => true
  validates :isbn,              :presence => true
  validates :box_no,            :presence => true
  validates :crate_id,          :presence => true
  
  before_validation :set_references
  validate :validate_references
  validates_associated :procurementitem, :invoice # to check received_cnt <= quantity
  
  belongs_to :crate, :counter_cache => :total_cnt
  belongs_to :procurementitem, :counter_cache => :received_cnt
  belongs_to :box, :counter_cache => :total_cnt
  belongs_to :po
  belongs_to :invoice, :counter_cache => :received_cnt
  
  attr_accessible :po_no, :invoice_no, :isbn, :box_no, :crate_id
  attr_readonly :crate_id, :procurementitem_id, :box_id, :po_id, :invoice_id
  
  private
  
    # a titlereceipt has references to po, invoice, procurementitem, box & crate
    # the crate_id is passed directly, while the others have to be found out
    def set_references
      self.po = Po.from_po_no(po_no).first
      self.po_no = po.code unless po.nil? # the scope above does some jugglery
      self.invoice = Invoice.find_by_invoice_no_and_po_id(invoice_no, po.id) unless po.nil?
      self.procurementitem = Procurementitem.find_by_po_number_and_isbn(po_no, isbn)
      self.box = Box.find_by_box_no_and_po_no_and_invoice_no(box_no, po_no, invoice_no)
    end
    
    def validate_references
      errors.add(:po_no, "PO is invalid!") if po.nil?
      errors.add(:invoice_no, "Invoice is invalid!") if invoice.nil?
      errors.add(:isbn, "ISBN not found in PO") if procurementitem.nil?
      errors.add(:crate_id, "Crate Not Valid") if crate.nil?      
      errors.add(:box_no, "Box Not Valid") if box.nil? 
      
      unless procurementitem.nil? 
        errors.add(:procurementitem_id, "Order Quantity Exceeded") unless procurementitem.received_cnt < procurementitem.quantity
      end
      
      unless invoice.nil?
        errors.add(:invoice_id, "Order Quantity Exceeded") unless invoice.received_cnt < invoice.quantity
      end
    end
end
