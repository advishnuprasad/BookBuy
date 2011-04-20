module BookreceiptsHelper
  def branch_for_book_no(book_no)
    Po.find_by_code(Bookreceipt.find_by_book_no(book_no).po_no).branch
  end
end
