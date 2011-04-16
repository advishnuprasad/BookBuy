module InvoicesHelper
  def fetch_open_pos
    Po.open
  end
end
