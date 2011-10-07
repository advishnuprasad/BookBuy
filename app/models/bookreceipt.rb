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
  after_validation              :populate_invoice_and_po_ids
  after_create                  :update_procurement_item_cnt
  after_create                  :update_book_no_in_titlereceipt
  
  belongs_to :created_by_user, :foreign_key => "created_by", :class_name => "User"
  belongs_to :modified_by_user, :foreign_key => "modified_by", :class_name => "User"
  attr_accessor :titlereceipt_id
    
  validates :po_no,             :presence => true
  validates :invoice_no,        :presence => true
  validates :isbn,              :presence => true
  validates :book_no,           :presence => true
  validates :crate_id,          :presence => true
  
  validate :book_no_should_not_have_been_used
  validate :invoice_no_should_exist
  

  
  scope :of_user_for_today, lambda { |user_id|
      {:conditions => ['created_by = ? AND created_at >= ? AND created_at <= ?', user_id, Time.zone.today.beginning_of_day, Time.zone.today.end_of_day]}
    }
  
  
  def invoice_no_should_exist
    unless invoice_no.blank?
      po = Po.find_by_code(po_no)
      invoice = Invoice.find_by_invoice_no_and_po_id(invoice_no, po.id)
      if invoice.nil?
        errors.add(:invoice_no, " is invalid!")
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
  
  
  def find_order_item
    unless isbn.blank?
      boxes = Crate.find(crate_id).boxes
      
      boxes.each do |box|
        Procurementitem.to_be_procured(isbn, box.po_no).each do |item|
          Titlereceipt.of_po_inv_box_and_isbn(box.po_no, box.invoice_no, box.box_no, isbn).each do |titlereceipt|
            self.po_no = titlereceipt.po_no
            self.invoice_no = titlereceipt.invoice_no
            self.titlereceipt_id = titlereceipt.id
            self.title_id = item.enrichedtitle.title_id
            break
          end
        end
      end
      
      if po_no.blank?
        errors.add(:isbn, " not found among items to Catalog")
      end
    end
  end
  
  def destroy
    decr_procurement_item_cnt
    remove_book_no_in_titlereceipt
    super
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
    
    
    def update_procurement_item_cnt
      item = Procurementitem.find_by_po_number_and_isbn(po_no, isbn)
      item.procured_cnt ||= 0
      item.procured_cnt = item.procured_cnt + 1
      item.save!
    end
    
    def decr_procurement_item_cnt
      item = Procurementitem.find_by_po_number_and_isbn(po_no, isbn)
      item.procured_cnt = item.procured_cnt - 1
      item.save!
    end
    
    def update_book_no_in_titlereceipt
      title = Titlereceipt.not_cataloged.find(titlereceipt_id)
      title.book_no = book_no
      title.save!
    end
    
    def remove_book_no_in_titlereceipt
      title = Titlereceipt.find_by_book_no(book_no)
      title.book_no = ''
      title.save!
    end
    
    def populate_invoice_and_po_ids
      unless po_no.blank?
        po = Po.find_by_code(po_no)
        self.po_id = po.id
        invoice = Invoice.find_by_invoice_no_and_po_id(invoice_no, po.id)
        self.invoice_id = invoice.id
      end
    end
end
