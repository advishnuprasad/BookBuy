# == Schema Information
# Schema version: 20110621102402
#
# Table name: bookreceipts
#
#  id          :integer(38)     not null, primary key
#  book_no     :string(255)     not null
#  po_no       :string(255)     not null
#  invoice_no  :string(255)     not null
#  isbn        :string(255)     not null
#  title_id    :integer(38)     not null
#  created_at  :timestamp(6)
#  updated_at  :timestamp(6)
#  crate_id    :integer(38)     not null
#  created_by  :integer(38)
#  modified_by :integer(38)
#  invoice_id  :integer(38)
#  po_id       :integer(38)
#

class Bookreceipt < ActiveRecord::Base
  before_validation             :find_order_item
  before_validation             :select_full_po_no
  before_create                 :set_title_id
  after_validation              :populate_invoice_and_po_ids
  after_create                  :update_procurement_item_cnt
  after_create                  :update_book_no_in_titlereceipt
  
  validates :po_no,             :presence => true
  validates :invoice_no,        :presence => true
  validates :isbn,              :presence => true
  validates :book_no,           :presence => true
  validates :crate_id,          :presence => true
  
  validate :book_no_should_not_have_been_used
  validate :po_no_should_exist
  validate :invoice_no_should_exist
  validate :isbn_should_be_part_of_po
  validate :crate_no_should_exist
  
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
  
  def book_no_should_not_have_been_used
    unless book_no.blank?
      book = Bookreceipt.find_by_book_no(book_no)
      unless book.nil?
        errors.add(:book_no, " has already been used!")
      end
    end
  end
  
  def crate_no_should_exist
    unless crate_id.blank?
      crate = Crate.find(crate_id)
      if crate.nil?
        errors.add(:crate_id, " is invalid!");
      end
    end
  end
  
  def find_order_item
    unless isbn.blank?
      po_nos = Crate.find(crate_id).boxes.collect {|box| box.po_no}
      Procurementitem.to_be_procured(isbn, po_nos).each do |item|
        Titlereceipt.of_po(item.po_number, isbn).each do |titlereceipt|
          self.po_no = titlereceipt.po_no
          self.invoice_no = titlereceipt.invoice_no
          break
        end
      end
    end
  end
  
  private
    
    def select_full_po_no
      unless po_no.blank?
        if po_no.length == 9
          po_item = Po.where("code LIKE :po_no", {:po_no => "#{po_no}%"})
          self.po_no = po_item[0].code
        end
      end
    end
    
    def set_title_id
      item = Procurementitem.find_by_po_number_and_isbn(po_no, isbn)
      if item
        self.title_id = item.enrichedtitle.title_id
      end
    end
    
    def update_procurement_item_cnt
      item = Procurementitem.find_by_po_number_and_isbn(po_no, isbn)
      if item
        item.procured_cnt = item.procured_cnt + 1
        item.save
      end
    end
    
    def update_book_no_in_titlereceipt
      title = Titlereceipt.not_cataloged.find_by_po_no_and_invoice_no_and_isbn(po_no, invoice_no, isbn)
      if title
        title.book_no = book_no
        title.save
      end
    end
    
    def populate_invoice_and_po_ids
      po = Po.find_by_code(po_no)
      self.po_id = po.id
      invoice = Invoice.find_by_invoice_no_and_po_id(invoice_no, po.id)
      self.invoice_id = invoice.id
    end
end
