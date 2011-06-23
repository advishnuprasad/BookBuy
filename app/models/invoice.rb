# == Schema Information
# Schema version: 20110623145106
#
# Table name: invoices
#
#  id              :integer(38)     not null, primary key
#  invoice_no      :string(255)
#  po_id           :integer(38)
#  date_of_receipt :timestamp(6)
#  quantity        :integer(38)
#  amount          :decimal(, )
#  created_at      :timestamp(6)
#  updated_at      :timestamp(6)
#  boxes_cnt       :integer(38)
#  date_of_invoice :timestamp(6)
#  created_by      :integer(38)
#  modified_by     :integer(38)
#

# == Schema Information
# Schema version: 20110614110459
#
# Table name: invoices
#
#  id              :integer(38)     not null, primary key
#  invoice_no      :string(255)
#  po_id           :integer(38)
#  date_of_receipt :datetime
#  quantity        :integer(38)
#  amount          :decimal(, )
#  created_at      :datetime
#  updated_at      :datetime
#  boxes_cnt       :integer(38)
#  date_of_invoice :datetime
#  created_by      :integer(38)
#  modified_by     :integer(38)
#

require 'barby'
require 'barby/outputter/png_outputter'

class Invoice < ActiveRecord::Base
  belongs_to :po, :counter_cache => true
  
  validates :invoice_no,              :presence => true
  validates :po_id,                   :presence => true
  validates :date_of_receipt,         :presence => true
  validates :date_of_invoice,         :presence => true
  validates :quantity,                :presence => true
  validates :amount,                  :presence => true
  validates :boxes_cnt,               :presence => true
  
  validate  :po_val_greater_than_total_invoices_val
  
  has_many :invoiceitems
  has_many :bookreceipts

  before_create :make_uppercase
  after_create :generate_barcodes
  
  scope :today, lambda { where("created_at >= ? and created_at <= ?",  Time.zone.today.to_time.beginning_of_day, Time.zone.today.to_time.end_of_day) }
  scope :created_on, lambda {|date| 
      {:conditions => ['created_at >= ? AND created_at <= ?', Time.zone.date.to_time.beginning_of_day, Time.zone.date.to_time.end_of_day]} 
    }
  scope :created_between, lambda {|startdate, enddate| 
      {:conditions => ['created_at >= ? AND created_at <= ?', startdate, enddate]}
    }
  scope :invoice_date_between, lambda {|startdate, enddate| 
      {:conditions => ['date_of_invoice >= ? AND date_of_invoice <= ?', startdate, enddate]}
    }
  
  def formatted_po_name
    po.code[0..po.code.index('/',5)-1]
  end
  
  def formatted_po_file_name
    po.code[0..po.code.index('/',5)-1].gsub(/\//,'_')
  end
  
  def formatted_invoice_name
    invoice_no.gsub(/\//,'_')
  end
  
  def regenerate
    generate_barcodes
  end
  
  def self.filter_by_invoice_date(params)
    created = params[:raised]
    if created == 'All'
      Invoice.paginate(:per_page => 250, :page => params[:page])
    else
      start_d_s = params[:start]
      end_d_s = params[:end]
      start_s = ""
      end_s = ""
      
      if (!start_d_s.nil?)
        start_s = start_d_s["start(3i)"] + '-' + start_d_s["start(2i)"] +'-'+ start_d_s["start(1i)"]
      end
      if (!end_d_s.nil?)
        end_s = end_d_s["end(3i)"] + '-' + end_d_s["end(2i)"] +'-'+ end_d_s["end(1i)"]
      end
      
      start_date = Time.zone.today.beginning_of_day
      end_date =  Time.zone.today.end_of_day
      
      if created == 'Today'
        start_date = Time.zone.today.beginning_of_day
        end_date =  Time.zone.today.end_of_day
      elsif created == 'Range'
        start_date = start_s.to_time.beginning_of_day
        end_date =  end_s.to_time.beginning_of_day
      elsif created == 'On'
        start_date = start_s.to_time.beginning_of_day
        end_date =  start_s.to_time.end_of_day
      end
      
      Invoice.invoice_date_between(start_date, end_date).paginate(:per_page => 250, :page => params[:page])
    end   
  end
  
  def self.filter_by_entry_date(params)
    created = params[:entered]
    if created == 'All'
      Invoice.paginate(:per_page => 250, :page => params[:page])
    else
      start_d_s = params[:start]
      end_d_s = params[:end]
      start_s = ""
      end_s = ""
      
      if (!start_d_s.nil?)
        start_s = start_d_s["start(3i)"] + '-' + start_d_s["start(2i)"] +'-'+ start_d_s["start(1i)"]
      end
      if (!end_d_s.nil?)
        end_s = end_d_s["end(3i)"] + '-' + end_d_s["end(2i)"] +'-'+ end_d_s["end(1i)"]
      end
      
      start_date = Time.zone.today.beginning_of_day
      end_date =  Time.zone.today.end_of_day
      
      if created == 'Today'
        start_date = Time.zone.today.beginning_of_day
        end_date =  Time.zone.today.end_of_day
      elsif created == 'Range'
        start_date = start_s.to_time.beginning_of_day
        end_date =  end_s.to_time.beginning_of_day
      elsif created == 'On'
        start_date = start_s.to_time.beginning_of_day
        end_date =  start_s.to_time.end_of_day
      end
      
      Invoice.created_between(start_date, end_date).paginate(:per_page => 250, :page => params[:page])
    end   
  end
  
  def destroy
    #raise Exceptions::InvoiceInUse unless Titlereceipt.of_invoice(invoice_no).count == 0
    if Titlereceipt.of_invoice(invoice_no).count != 0
      return false
    else
      super
      return true
    end
  end
  
  def get_bookreceipts_invoiceitems
      
    sql_stmt = "select b.isbn isbn, count(b.isbn) cnt, ii.isbn ii_isbn, ii.quantity quantity, "+
                              " decode( (count(b.isbn) - ii.quantity), 0, 'Same',-1, 'Over',1, 'Under', 'diff') diff" +
                              " from invoiceitems ii, bookreceipts b where ii.invoice_id = b.invoice_id " +
                              " and trim(ii.isbn) = trim(b.isbn) "+
                              " and b.invoice_id= #{self.id.to_s} and ii.invoice_id= #{self.id.to_s} group by b.isbn, ii.isbn, ii.quantity "
    bookreceipt_invoiceitems = Bookreceipt.find_by_sql(sql_stmt)

  end
  
  def get_extra_bookreceipts 
  
    sql_stmt =  "SELECT '' isbn, 0 cnt, ii.isbn ii_isbn, ii.quantity quantity, 'Over' diff" +
                    " FROM invoiceitems ii " +
                    " WHERE (ii.invoice_id , trim(ii.isbn) ) NOT IN "+
                      "(SELECT  invoice_id, trim(isbn) FROM bookreceipts WHERE invoice_id = #{self.id.to_s}) "+
                       " AND invoice_id = #{self.id.to_s} "+ 
                    " GROUP BY '', 0, ii.isbn, ii.quantity "
                    
      bookreceipts = Invoiceitem.find_by_sql(sql_stmt)

  end
  
  def get_extra_invoiceitems
  
    sql_stmt =  "SELECT b.isbn isbn, COUNT(b.isbn) cnt,'' ii_isbn, 0 quantity, 'Under' diff"+
                " FROM Bookreceipts b  WHERE (b.invoice_id , trim(b.isbn) ) NOT IN "+
                " (select  invoice_id, trim(isbn) FROM invoiceitems WHERE "+
                " invoice_id = #{self.id.to_s}) "+
                " AND invoice_id = #{self.id.to_s} "+
                " GROUP BY  b.isbn, '',0 " +
                " ORDER BY 2 DESC "
    bookreceipts = Bookreceipt.find_by_sql(sql_stmt)
    
  end
  
  private 
    def make_uppercase
      self.invoice_no = self.invoice_no.upcase
    end

    def generate_barcodes
      postr = formatted_po_name
      pofilename = formatted_po_file_name
      invstr = formatted_invoice_name
      
      pobarcode = Barby::Code128B.new(postr)
      invbarcode = Barby::Code128B.new(invoice_no)

      File.open('public/images/' + pofilename + '.png', 'wb') do |f|
        f.write pobarcode.to_png
      end
      File.open('public/images/' + invstr + '.png', 'wb') do |f|
        f.write invbarcode.to_png
      end
    end
    
    def po_val_greater_than_total_invoices_val
      po_temp = Po.find(po_id)
      if po_temp
        total_util_so_far = po_temp.invoices.collect{|x| x.amount}.sum
        total_qty_so_far = po_temp.invoices.collect{|x| x.quantity}.sum
        if total_util_so_far + amount > po_temp.netamt
          errors.add(:amount, " - Total invoices amount exceeds PO value")
        elsif total_qty_so_far + quantity > po_temp.copies_cnt
          errors.add(:quantity, " - Total invoices quantity exceeds PO copies")
        end
      end
    end
end
