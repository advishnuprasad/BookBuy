module InvoicesHelper
  def invoices_of(po_no)
    po = Po.find(po_no)
    return po.invoices
  end
end
