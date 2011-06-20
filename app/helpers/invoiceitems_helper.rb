module InvoiceitemsHelper

  def sum_attr(attr_name, invoice_items)
      attr_sum = 0
      invoice_items.each { |item|
        attr_sum += item[attr_name]   
      }
      
      return attr_sum
  end

end
