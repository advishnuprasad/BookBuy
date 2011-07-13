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
  attr_accessor                 :error_messages
  
  before_validation             :select_full_po_no
  after_validation              :check_for_errors
  before_create                 :upsert_box_total_cnt
  after_create                  :update_procurement_item_cnt
  
  scope :valid, where("error is NULL")
  scope :of_po_and_isbn, lambda { |po_no, isbn|
      valid.
      where("po_no = :po_no AND isbn = :isbn", {:po_no => po_no, :isbn => isbn}).
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
  
  validate :po_no_should_exist
  validate :invoice_no_should_exist
  validate :isbn_should_be_part_of_po
  
  validate_on_create :excess_quantity
  
  def after_initialize
    @error_messages = Hash.new
  end
  
  def po_no_should_exist
    unless po_no.blank?
      po = Po.find_by_code(po_no)
      if po.nil?
        @error_messages[:po_no] = "PO is invalid!"
      end
    end
  end
  
  def invoice_no_should_exist
    unless invoice_no.blank?
      po = Po.find_by_code(po_no)
      invoice = Invoice.find_by_invoice_no_and_po_id(invoice_no, po.id)
      if invoice.nil?
        @error_messages[:invoice_no] = "Invoice is invalid!"
      end
    end
  end
  
  def isbn_should_be_part_of_po
    unless isbn.blank?
      item = Procurementitem.find_by_po_number_and_isbn(po_no, isbn)
      if item.nil?
        @error_messages[:isbn] = "ISBN not found in PO!"
      end
    end
  end
  
  def excess_quantity
    po = Procurementitem.find_by_po_number_and_isbn(po_no, isbn)
    if po
      order_qty = po.quantity
      titlereceipt = Titlereceipt.of_po_and_isbn(po_no, isbn)
      if titlereceipt
        scan_cnt = titlereceipt.count
        if scan_cnt == order_qty
          @error_messages[:isbn] = "ISBN's order quantity exceeded!"
        end
      end
    end
  end
  
  def destroy
    decr_procurement_item_cnt
    decr_box_total_cnt
    super
  end
  
  private
    def select_full_po_no
      if po_no.length == 9
        po_item = Po.where("code LIKE :po_no", {:po_no => "#{po_no}%"})
        if po_item
          self.po_no = po_item[0].code
        end
      end
    end
    
    def check_for_errors
      if @error_messages.count > 0
        str = @error_messages.values.join(" ")
        error = ""
        if str.include?("order quantity exceeded")
          error = "Order Quantity Exceeded"
        elsif str.include?("not found in PO")
          error = "ISBN not found in PO"
        elsif str.include?("PO is invalid")
          error = "PO is invalid"
        elsif str.include?("Invoice is invalid")
          error = "Invoice is invalid"
        end
        self.error = error
      end
    end
    
    def update_procurement_item_cnt
      if @error_messages.count == 0
        item = Procurementitem.find_by_po_number_and_isbn(po_no, isbn)
        if item
          item.received_cnt ||= 0
          item.received_cnt = item.received_cnt + 1
          item.save
        end
      end
    end
    
    def decr_procurement_item_cnt
      item = Procurementitem.find_by_po_number_and_isbn(po_no, isbn)
      if item
        item.received_cnt = item.received_cnt - 1
        item.save
      end
    end
    
    def upsert_box_total_cnt
      if @error_messages.count == 0
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
    
    def decr_box_total_cnt
      box = Box.find_by_box_no_and_po_no_and_invoice_no(box_no, po_no, invoice_no)
      box.total_cnt = box.total_cnt - 1
      box.save
    end
end
