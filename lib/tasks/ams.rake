namespace :enrich do
  desc "Enrich Data"
  task :titles => :environment do
    Enrichedtitle.valid.where("web_scanned is null").each do |et|
      begin
        finfo = FlipkartInfo.book_info(et.isbn)

        unless finfo.nil?
          # this data also comes from the corelist, therefore, we store it in the web_fields, for comparisons later
          et.web_title = finfo[:title].slice(0,200)
          et.web_author =  finfo[:authors].slice(0,200)
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
      puts "saving #{et.isbn}"
      et.save!
    end
  end
end

namespace :create do
  desc "Create Title From Web"
  task :titles => :environment do
    conn = Enrichedtitle.connection
    cur = conn.execute("select isbn from isbnsnotinet minus select isbn from enrichedtitles ")
    while r = cur.fetch()
      begin
        et = Enrichedtitle.new_from_web(r[0])
        unless et.web_scanned.nil?
          et.currency = 'INR'
          et.language = 'English' if et.language.nil?
          et.listprice = 0 if et.listprice.nil? # in case of out of stock
          if et.valid?
            puts "saving #{r}"
            et.save!
          else
            puts "errors while saving #{r} - #{et.errors}"
          end
        else
          puts "skipping #{r}"
        end
      rescue
        puts "failed for #{r}"
      end
    end
  end
end


namespace :load do
  desc "Loads Title From Web"
  task :titles => :environment do
    conn = Enrichedtitle.connection
    columns = {
      :title => 0,
      :author => 1,
      :isbn => 2,
      :publisher => 3,
      :format => 4,
      :pages => 5,
      :content_language => 6,
      :dimensions => 7,
      :category1 => 8,
      :release_date => 9,
      :weight => 10,
      :pubyear => 11
    }
    cur = conn.execute("select title,author,isbn,publisher,format,pages,content_language,dimensions,category1,release_date,weight,pubyear from ISBNSFROMREADERWARE where isbn IN (select isbn from ISBNSFROMREADERWARE minus select isbn from enrichedtitles) order by isbn ")
    while r = cur.fetch()
      begin
        attributes = {
          :isbn => r[columns[:isbn]],

          :title => r[columns[:title]],
          :author =>  r[columns[:author]],
          :publisher => r[columns[:publisher]],
          :pubdate => r[columns[:release_date]],
          :language => r[columns[:content_language]],
          :listprice => 0,
          :image_url => "https://s3.amazonaws.com/dev.justbooksclc.com/readerware/#{r[columns[:isbn]]}.jpg",

          # web related fields, these are set by default, and not allowed to change in the UI
          :web_title => r[columns[:title]],
          :web_author =>  r[columns[:author]],
          :web_listprice => 0,
          :web_language => r[columns[:content_language]],
          :web_category => r[columns[:category1]],

          # new fields
          :format => r[columns[:format]],
          :page_cnt => r[columns[:pages]],
          :dimensions => r[columns[:dimensions]],
          :weight => r[columns[:weight]],
          :pub_year => r[columns[:pubyear]],
          :publisher_name => r[columns[:publisher]],

          :web_scanned => 'Readerware'
        }
        
        et = Enrichedtitle.new(attributes)
        et.currency = 'INR'
        et.language = 'English' if et.language.nil?
        et.listprice = 0 if et.listprice.nil? # in case of out of stock
        et.category.slice!(0,200) unless et.category.nil?
        if et.valid?
          puts "saving #{r}"
          et.save!
        else
          puts "errors while saving #{r} - #{et.errors}"
        end
      rescue
        puts "failed for #{r}"
      end
    end
  end
end

namespace :modify do
  desc "Modify Enriched Titles with new rates"
  task :listprice => :environment do
    conn = Enrichedtitle.connection
    columns = {
      :isbn => 0,
      :currency => 1,
      :price => 2
    }    
    cur = conn.execute("select isbn,currency,price from et_upd_price")
    while r = cur.fetch()
      begin
        et = Enrichedtitle.find_by_isbn(r[columns[:isbn]].to_s)
        if et.valid?
          # update only if something's changing, to avoid un-necessary versions
          if et.currency != r[columns[:currency]] or et.listprice != r[columns[:price]]
            et.currency = r[columns[:currency]]
            et.listprice = r[columns[:price]]
            if et.valid?
              puts "saving #{r[columns[:isbn]]}"
              et.save!
            else
              puts "errors while saving #{r[columns[:isbn]]} - #{et.errors}"
            end
          else
            puts "skipping ISBN, no change in listprice & currency"
          end
        else
          puts "skipping ISBN as it is invalid - please fix the isbn first #{r[columns[:isbn]]}"
        end
      rescue
        puts "failed for #{r[columns[:isbn]]}"
      end
    end
  end
end