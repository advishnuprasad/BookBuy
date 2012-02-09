namespace :enrich do
  desc "Enrich Data"
  task :titles => :environment do
    Enrichedtitle.valid.where("web_scanned is null").each do |et|
      begin
        finfo = FlipkartInfo.book_info(et.isbn)

        unless finfo.nil?
          # this data also comes from the corelist, therefore, we store it in the web_fields, for comparisons later
          et.web_title = finfo[:title]
          et.web_author =  finfo[:authors]
          et.web_listprice = finfo[:listprice]
          et.web_language = finfo[:language]
    
          # this data does not come through the file, so we do it here
          et.image_url = finfo[:image] if et.cover_file_size.nil?
          et.format = finfo[:format]
          et.page_cnt = finfo[:page_cnt]
          et.publisher_name = finfo[:publisher]
          et.dimensions = finfo[:dimensions]
          et.weight = finfo[:weight]
          et.pub_year = finfo[:pubdate]
          et.web_category = finfo[:category].slice(0,200)
        
          et.web_scanned = 'Done'
    
        else
          et.web_scanned = 'Failed'
        end
      rescue
        et.web_scanned = 'Failed'
      end
      et.save    
    end
  end
end