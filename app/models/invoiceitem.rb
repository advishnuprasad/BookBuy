# == Schema Information
# Schema version: 20110617100008
#
# Table name: invoiceitems
#
#  id             :integer(38)     not null, primary key
#  invoice_id     :integer(38)
#  quantity       :integer(38)
#  author         :string(255)
#  title          :string(255)
#  isbn           :string(255)
#  publisher      :string(255)
#  currency       :string(255)
#  unit_price     :decimal(, )
#  unit_price_inr :decimal(, )
#  conv_rate      :decimal(, )
#  discount       :decimal(, )
#  net_amount     :decimal(, )
#  user_id        :integer(38)
#  created_at     :datetime
#  updated_at     :datetime
#

class Invoiceitem < ActiveRecord::Base

  belongs_to :invoice
  
  validates :isbn, :presence => true
  validates :quantity, :presence => true
  validates :invoice_id, :presence => true
  validates :currency, :presence => true
  validates :quantity, :presence => true
  validates :unit_price, :presence => true
  validates :unit_price_inr, :presence => true
  validates :conv_rate, :presence => true
  validates :discount, :presence => true
  validates :net_amount, :presence => true
  before_validation_on_create  :set_data
  
  def set_data
    if (self.currency.upcase.eql?('INR') and (self.conv_rate.nil? or self.conv_rate.blank? ))
      self.conv_rate = 1
    end
    
    if (self.currency.upcase.eql?('INR') and (self.unit_price_inr.nil? or self.unit_price_inr.blank? ))
      self.unit_price_inr = self.unit_price
    end
  end
  
  def copy_data(csv, user_id)
    self.invoice_id = csv.invoice_id
    self.quantity = csv.quantity
    self.author = csv.author
    self.title = csv.title
    self.isbn = csv.isbn
    self.publisher = csv.publisher
    self.currency = csv.currency
    self.unit_price = csv.unit_price
    self.unit_price_inr = csv.unit_price_inr
    self.conv_rate = csv.conv_rate
    self.discount = csv.discount
    self.net_amount = csv.net_amount
    self.user_id = user_id
  end
end
