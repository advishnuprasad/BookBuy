module TitlereceiptsHelper
  def title_for_isbn(isbn)
    if isbn.length == 13 then
      Enrichedtitle.find_by_isbn(isbn).title
    elsif isbn.length == 10 then
      Enrichedtitle.find_by_isbn10(isbn).title
    else
      "No Title Found"
    end
  end
end
