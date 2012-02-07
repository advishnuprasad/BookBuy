class AddWebFieldsToEnrichedtitles < ActiveRecord::Migration
  def self.up
    add_column :enrichedtitles, :format, :string
    add_column :enrichedtitles, :page_cnt, :integer
    add_column :enrichedtitles, :publisher_name, :string
    add_column :enrichedtitles, :dimensions, :string
    add_column :enrichedtitles, :weight, :string
    add_column :enrichedtitles, :pub_year, :integer
    add_column :enrichedtitles, :web_title, :string
    add_column :enrichedtitles, :web_author, :string
    add_column :enrichedtitles, :web_listprice, :string
    add_column :enrichedtitles, :web_language, :string
    add_column :enrichedtitles, :web_scanned, :string
    add_column :enrichedtitles, :web_category, :string
        
    add_column :enrichedtitle_versions, :format, :string
    add_column :enrichedtitle_versions, :page_cnt, :integer
    add_column :enrichedtitle_versions, :publisher_name, :string
    add_column :enrichedtitle_versions, :dimensions, :string
    add_column :enrichedtitle_versions, :weight, :string
    add_column :enrichedtitle_versions, :pub_year, :integer
    add_column :enrichedtitle_versions, :web_title, :string
    add_column :enrichedtitle_versions, :web_author, :string
    add_column :enrichedtitle_versions, :web_listprice, :string
    add_column :enrichedtitle_versions, :web_language, :string
    add_column :enrichedtitle_versions, :web_scanned, :string
    add_column :enrichedtitle_versions, :web_category, :string
        
  end

  def self.down
    remove_column :enrichedtitles, :pub_year
    remove_column :enrichedtitles, :weight
    remove_column :enrichedtitles, :dimensions
    remove_column :enrichedtitles, :publisher_name
    remove_column :enrichedtitles, :page_cnt
    remove_column :enrichedtitles, :format
    remove_column :enrichedtitles, :web_title
    remove_column :enrichedtitles, :web_author
    remove_column :enrichedtitles, :web_listprice
    remove_column :enrichedtitles, :web_language
    remove_column :enrichedtitles, :web_scanned
    remove_column :enrichedtitles, :web_category
    

    remove_column :enrichedtitle_versions, :pub_year
    remove_column :enrichedtitle_versions, :weight
    remove_column :enrichedtitle_versions, :dimensions
    remove_column :enrichedtitle_versions, :publisher_name
    remove_column :enrichedtitle_versions, :page_cnt
    remove_column :enrichedtitle_versions, :format
    remove_column :enrichedtitle_versions, :web_title
    remove_column :enrichedtitle_versions, :web_author
    remove_column :enrichedtitle_versions, :web_listprice
    remove_column :enrichedtitle_versions, :web_language    
    remove_column :enrichedtitle_versions, :web_scanned
    remove_column :enrichedtitle_versions, :web_category  
  end
end
