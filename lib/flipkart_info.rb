module FlipkartInfo
  def self.book_info(isbn)
    url = "http://www.flipkart.com/search.php?query=#{isbn}"
    page = Mechanize.new.get(url)

    title = nil
    authors = nil
    publisher = nil
    pubdate = nil
    binding = nil
    page_cnt = nil
    language = nil
    awards = nil
    summary = nil
    isbn10 = nil
    dimensions = nil
    weight = nil
    listprice = nil
    category = nil

    product_details = page.search("div#details table.fk-specs-type1 tr")
    if product_details.length != 0
      product_details.each do |product_detail|
        next if product_detail.children.empty?
        key = product_detail.children[0].text.strip.encode('UTF-8').gsub(":", "")
        value = product_detail.children[1].text.strip.encode('UTF-8')
        case key
        when "Book"
          title = value
        when "Author"
          authors = value
        when "Publisher"
          publisher = value
        when "Publishing Date"
          pubdate = value
        when "Binding"
          binding = value
        when "Number of Pages"
          page_cnt = value
        when "Language"
          language = value
        when "Awards"
          awards = value
        when "ISBN"
          isbn10 = value
        when "Dimensions"
          dimensions = value
        when "Weight"
          weight = value
        end
      end
    else
      return nil
    end

    image = nil
    image_tag = page.search("div#mprodimg-id img")
    unless image_tag.empty?
      image = image_tag.attr('src').text.encode('UTF-8')
    end

#    summary is no longer available in the body
#    summary_detail = page.search("div.item_desc_text.description")
#    if summary_detail.length != 0 
#      summary = summary_detail.inner_text.strip.encode('UTF-8')
#    end
    
    summary_match = page.body.match /var full_description = (.*)/
    summary = summary_match[0] unless summary_match.nil?
    
    lp_span = page.search("span#fk-mprod-list-id")
    listprice = lp_span.text.encode('UTF-8') unless lp_span.nil?
    fkp_span = page.search("span#fk-mprod-our-id")
    if listprice.blank?
      listprice = fkp_span.text.encode('UTF-8') unless fkp_span.nil?
    end
    
    category_span = page.search("div.line.bread-crumbs.fksk-bread-crumbs")
    category = category_span.text.gsub(/\r?\n?/, "").strip.encode('UTF-8') unless category_span.nil?
    
    {
      :info_source => "flipkart",
      :title => title,
      :authors => FlipkartInfo.encode_string(authors),
      :publisher => publisher,
      :image => image,
      :pubdate => pubdate,
      :format => binding,
      :page_cnt => page_cnt,
      :language => language,
      :isbn10 => isbn10,
      :dimensions => dimensions,
      :weight => weight,
      :listprice => listprice,
      :awards => awards,
      :summary => summary,
      :category => category
    }
  end
  
  def self.encode_string(untrusted_string)
    return '.' if untrusted_string.nil?
    return untrusted_string if untrusted_string.valid_encoding?
    
    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
    ic.iconv(untrusted_string + ' ')[0..-2]
  end
end
