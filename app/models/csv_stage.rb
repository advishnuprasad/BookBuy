# == Schema Information
# Schema version: 20110713050822
#
# Table name: csv_stages
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
#  error          :string(255)
#  created_at     :timestamp(6)
#  updated_at     :timestamp(6)
#

class CsvStage < ActiveRecord::Base
  
  
  before_save :set_error
  def set_error
    error = ""
    if quantity.nil? or quantity.blank? or quantity < 0 or quantity > 1000
      error += 'invalid quantity;'
    end
    if isbn.include?('+') or isbn.include?('.') or isbn.nil? or isbn.blank?
      error += 'invalid isbn;'
    end
    
    if currency.nil? or currency.blank?
      error += 'invalid currency;'
    end
    if unit_price.nil? or unit_price.blank? or unit_price == 0
      error += 'incorrect unit price;'
    end
    
    if discount.nil? or discount.blank?
      error += 'incorrect discount;'
    end
    if net_amount.nil? or net_amount.blank?
      error += 'incorrect net amount;'
    end
    
    if !currency.upcase.eql?('INR') and (unit_price_inr.nil? or unit_price_inr.blank? or unit_price_inr == 0)
      error += 'incorrect unit price in INR;'
    end
    
    if !currency.upcase.eql?('INR') and (conv_rate.nil? or conv_rate.blank? or conv_rate == 0)
      error += 'incorrect conversion rate;'
    end
    
    self.error = error
  end
end
