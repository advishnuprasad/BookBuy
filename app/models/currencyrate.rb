# == Schema Information
# Schema version: 20110717105125
#
# Table name: currencyrates
#
#  id             :integer(38)     not null, primary key
#  code1          :string(255)
#  code2          :string(255)
#  rate           :decimal(, )
#  effective_from :datetime
#  created_by     :integer(38)
#  modified_by    :integer(38)
#  created_at     :datetime
#  updated_at     :datetime
#

class Currencyrate < ActiveRecord::Base
  belongs_to :created_by_user, :foreign_key => "created_by", :class_name => "User"
  belongs_to :modified_by_user, :foreign_key => "modified_by", :class_name => "User"
  
  validates :rate,              :presence => true
  validates :effective_from,    :presence => true
  validates :code1,             :presence => true, :length => { :is => 3 }
  validates :code2,             :presence => true, :length => { :is => 3 }
  
  before_save :set_defaults
  
  validate_on_create :combination_should_be_unique, :code1_and_code2_should_be_different
  
  scope :fetch, lambda {|code1, code2, effective_from|
      {:conditions => ['((code1 = ? and code2 = ?) OR (code1 = ? and code2 = ?)) AND effective_from = ?', 
        code1, code2, code2, code1, effective_from] }
    }
  scope :get_rate, lambda {|code1, code2, effective_from|
      {:conditions => ['((code1 = ? and code2 = ?) OR (code1 = ? and code2 = ?)) ' +
        'AND effective_from = (SELECT MAX(effective_from) FROM currencyrates WHERE effective_from <= ?)', 
        code1, code2, code2, code1, effective_from] }
    }
  
  private
    def set_defaults
      self.code1 = code1.upcase
      self.code2 = code2.upcase
    end
    
    def combination_should_be_unique
      rate = Currencyrate.fetch(code1, code2, effective_from)
      unless rate.size == 0
        errors.add(:rate, " entry for the mentioned combination and date already exists!");
      end
    end
    
    def code1_and_code2_should_be_different
      if code1 == code2
        errors.add(:code1, " and Code 2 cannot be the same!");
      end
    end
end
