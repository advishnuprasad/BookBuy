# == Schema Information
# Schema version: 20110410134111
#
# Table name: pos
#
#  id             :integer(38)     not null, primary key
#  code           :string(255)     not null
#  supplier_id    :integer(38)     not null
#  branch_id      :integer(38)
#  raised_on      :timestamp(6)
#  titles_cnt     :integer(38)
#  copies_cnt     :integer(38)
#  status         :string(255)
#  user           :string(255)
#  created_at     :timestamp(6)
#  updated_at     :timestamp(6)
#  discount       :decimal(, )
#  publisher_id   :integer
#  typeofpo       :string(255)
#  convrate       :decimal(, )
#  grossamt       :decimal(, )
#  netamt         :decimal(, )
#  orgunit        :decimal(, )
#  suborgunit     :decimal(, )
#  expensehead    :decimal(, )
#  payby1         :timestamp(6)
#  payableamt1    :decimal(, )
#  payby2         :timestamp(6)
#  payableamt2    :decimal(, )
#  payby3         :timestamp(6)
#  payableamt3    :decimal(, )
#  narration      :string(255)
#  invoices_count :integer(38)
#  currency       :string(1020)
#  procurement_id :integer(38)
#

class Po < ActiveRecord::Base
  belongs_to :supplier
  belongs_to :publisher
  belongs_to :branch
  belongs_to :procurement
  has_many :procurementitems, :inverse_of => "po"
  has_many :invoices
  
  before_create :make_uppercase
  
  scope :open_pos, where(:status => 'O')
  scope :pos_with_invoices, where("invoices_count > ?",0)
  scope :pos_for_supplier, lambda { |supplier_id|
      where(:supplier_id => supplier_id)
    }
  scope :like, lambda { |q|
      open_pos.
      where("LOWER(code) LIKE LOWER(:q)",{:q => "#{q}%"})
    }
  scope :among, lambda {|po_nos|
      open_pos.
      where(:code => po_nos).
      order("id")
    }
  scope :today, lambda { 
      where("created_at >= ? and created_at <= ?",  Time.zone.today.to_time.beginning_of_day, Time.zone.today.to_time.end_of_day) 
    }
  scope :created_on, lambda {|date| 
      {:conditions => ['created_at >= ? AND created_at <= ?', Time.zone.date.to_time.beginning_of_day, Time.zone.date.to_time.end_of_day]}
    }
  scope :created_between, lambda {|startdate, enddate| 
      {:conditions => ['created_at >= ? AND created_at <= ?', Time.zone.startdate.to_time.beginning_of_day, Time.zone.enddate.to_time.end_of_day]}
    }
  scope :of_procurement, lambda {|procurement_id|
      where(:procurement_id => procurement_id)
    }
  
  def publishername
    Publisher.get_publisher_name(publisher_id)
  end
  
  private 
    def make_uppercase
      self.code = self.code.upcase
    end
end
