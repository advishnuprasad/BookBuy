class CreateNoisbntitles < ActiveRecord::Migration
  def self.up
    create_table :noisbntitles do |t|
      t.string      :title                ,:null => false
      t.string      :language             ,:null => false   
      t.string      :author               ,:null => false   
      t.string      :currency             ,:null => false   
      t.decimal     :listprice            ,:null => false   
      t.string      :verified             ,:null => false   
      t.string      :enriched             ,:null => false   
      t.string      :category_id          ,:null => false   
      t.string      :publisher_name       ,:null => false   
      t.integer     :pub_year             ,:null => false   
                                      
      t.string      :cover_remote_url  
      t.string      :cover_file_name   
      t.string      :cover_content_type
      t.integer     :cover_file_size   
      t.datetime    :cover_updated_at  
                                      
      t.string      :format            
      t.integer     :page_cnt          
      t.string      :dimensions       
      t.string      :weight            
                    
      t.references  :title               ,:null => false   
      t.references  :publisher           ,:null => false   
      
      t.string      :t_title
      t.string      :t_author
      
      t.timestamps
    end
    add_index :noisbntitles, :title_id, :unique => true
    add_index :noisbntitles, :publisher_id    
  end

  def self.down
    drop_table :noisbntitles
  end
end
