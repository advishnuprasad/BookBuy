# == Schema Information
# Schema version: 20110414104357
#
# Table name: bookreceipts
#
#  id         :integer(38)     not null, primary key
#  book_no    :string(255)
#  po_no      :string(255)
#  invoice_no :string(255)
#  isbn       :string(255)
#  title_id   :integer(38)
#  created_at :datetime
#  updated_at :datetime
#

class Bookreceipt < ActiveRecord::Base
  before_validation :select_full_po_no
  before_create :set_title_id
  
  validates :po_no,             :presence => true
  validates :invoice_no,        :presence => true
  validates :isbn,              :presence => true
  validates :book_no,           :presence => true
  
  validate :po_no_should_exist
  validate :invoice_no_should_exist
  validate :isbn_should_be_part_of_po
  validate :book_no_should_not_have_been_used
  
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
  
  def book_no_should_not_have_been_used
    unless book_no.blank?
      book = Bookreceipt.find_by_book_no(book_no)
      unless book.nil?
        errors.add(:book_no, " has already been used!")
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
    
    def set_title_id
      item = Procurementitem.find_by_po_number_and_isbn(po_no, isbn)
      if item
        self.title_id = item.enrichedtitle.title_id
      end
    end
end
