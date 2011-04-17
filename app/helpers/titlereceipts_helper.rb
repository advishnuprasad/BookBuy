module TitlereceiptsHelper
  def title_for_isbn(isbn)
    if isbn.length == 13 then
      Enrichedtitle.find_by_isbn(isbn)
    elsif isbn.length == 10 then
      Enrichedtitle.find_by_isbn10(isbn)
    else
      "No Title Found"
    end
  end
end
