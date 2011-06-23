# == Schema Information
# Schema version: 20110617100008
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
#

class Titlereceipt < ActiveRecord::Base
  before_validation             :select_full_po_no
  before_create                 :upsert_box_total_cnt
  after_create                  :update_procurement_item_cnt
  
  #TODO Change scope name to of_po_and_isbn
  scope :of_po, lambda { |po_no, isbn|
      where("po_no = :po_no AND isbn = :isbn", {:po_no => po_no, :isbn => isbn}).
      order("created_at")
    }  
  scope :of_invoice, lambda{|invoice_no|
      where(:invoice_no => invoice_no).
      order("created_at")
    }
  scope :not_cataloged, where("book_no IS NULL")
  
  validates :po_no,             :presence => true
  validates :invoice_no,        :presence => true
  validates :isbn,              :presence => true
  validates :box_no,            :presence => true
  
  validate :po_no_should_exist
  validate :invoice_no_should_exist
  validate :isbn_should_be_part_of_po
  
  validate_on_create :excess_quantity
  
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
      po = Po.find_by_code(po_no)
      invoice = Invoice.find_by_invoice_no_and_po_id(invoice_no, po.id)
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
  
  def excess_quantity
    po = Procurementitem.find_by_po_number_and_isbn(po_no, isbn)
    if po
      order_qty = po.quantity
      titlereceipt = Titlereceipt.of_po(po_no, isbn)
      if titlereceipt
        scan_cnt = titlereceipt.count
        if scan_cnt == order_qty
          errors.add(:po_no, "'s order quantity has already been received!")
        end
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
    
    def update_procurement_item_cnt
      item = Procurementitem.find_by_po_number_and_isbn(po_no, isbn)
      if item
        item.received_cnt ||= 0
        item.received_cnt = item.received_cnt + 1
        item.save
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
