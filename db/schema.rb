# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110410134111) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id",    :precision => 38, :scale => 0
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "corelist", :primary_key => "isbn", :force => true do |t|
    t.string  "title"
    t.string  "author"
    t.string  "publisher"
    t.decimal "publishercode"
    t.decimal "price"
    t.string  "currency",      :limit => 30
    t.string  "category"
    t.string  "subcategory"
    t.decimal "qty"
  end

  create_table "enrichedtitle_versions", :force => true do |t|
    t.integer  "enrichedtitle_id", :precision => 38, :scale => 0
    t.integer  "version",          :precision => 38, :scale => 0
    t.integer  "title_id",         :precision => 38, :scale => 0
    t.string   "title"
    t.integer  "publisher_id",     :precision => 38, :scale => 0
    t.string   "isbn"
    t.string   "language"
    t.string   "category"
    t.string   "subcategory"
    t.string   "isbn10"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "verified"
    t.string   "author"
    t.string   "isbnvalid"
    t.decimal  "listprice"
    t.string   "currency"
  end

  add_index "enrichedtitle_versions", ["enrichedtitle_id"], :name => "i_enr_ver_enr_id"

  create_table "enrichedtitles", :force => true do |t|
    t.integer  "title_id",     :precision => 38, :scale => 0
    t.string   "title"
    t.integer  "publisher_id", :precision => 38, :scale => 0
    t.string   "isbn"
    t.string   "language"
    t.string   "category"
    t.string   "subcategory"
    t.string   "isbn10"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",      :precision => 38, :scale => 0
    t.string   "verified"
    t.string   "author"
    t.string   "isbnvalid"
    t.decimal  "listprice"
    t.string   "currency"
  end

  create_table "enrichedtitles_bkp", :id => false, :force => true do |t|
    t.integer  "id",           :precision => 38, :scale => 0, :null => false
    t.integer  "title_id",     :precision => 38, :scale => 0
    t.string   "title"
    t.integer  "publisher_id", :precision => 38, :scale => 0
    t.string   "isbn"
    t.string   "language"
    t.string   "category"
    t.string   "subcategory"
    t.string   "isbn10"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",      :precision => 38, :scale => 0
    t.string   "verified"
    t.string   "author"
    t.string   "isbnvalid"
    t.decimal  "listprice"
    t.string   "currency"
  end

  create_table "pos", :force => true do |t|
    t.string   "number"
    t.integer  "supplier_id", :precision => 38, :scale => 0
    t.integer  "branch_id",   :precision => 38, :scale => 0
    t.datetime "raised_on"
    t.integer  "titles_cnt",  :precision => 38, :scale => 0
    t.integer  "copies_cnt",  :precision => 38, :scale => 0
    t.string   "status"
    t.string   "user"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "discount"
  end

  create_table "procurementitems", :force => true do |t|
    t.string   "source"
    t.integer  "source_id",        :precision => 38, :scale => 0
    t.integer  "enrichedtitle_id", :precision => 38, :scale => 0
    t.string   "isbn"
    t.string   "status"
    t.string   "po_number"
    t.string   "book_number"
    t.string   "cancel_reason"
    t.integer  "deferred_by",      :precision => 38, :scale => 0
    t.datetime "last_action_date"
    t.integer  "supplier_id",      :precision => 38, :scale => 0
    t.datetime "expiry_date"
    t.integer  "member_id",        :precision => 38, :scale => 0
    t.string   "card_id"
    t.integer  "branch_id",        :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",         :precision => 38, :scale => 0
  end

  create_table "publishers", :force => true do |t|
    t.string   "code"
    t.string   "imprintname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id",      :precision => 38, :scale => 0
    t.string   "publishername"
  end

  add_index "publishers", ["code"], :name => "index_publishers_on_code", :unique => true

  create_table "publisherxrefs", :force => true do |t|
    t.integer  "isbnpublishercode", :precision => 38, :scale => 0
    t.integer  "publisher_id",      :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supplierdiscounts", :force => true do |t|
    t.integer  "publisher_id", :precision => 38, :scale => 0
    t.integer  "supplier_id",  :precision => 38, :scale => 0
    t.decimal  "discount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suppliers", :id => false, :force => true do |t|
    t.integer "id",             :limit => nil, :null => false
    t.string  "name",           :limit => 100
    t.string  "contact",        :limit => 100
    t.string  "phone",          :limit => 100
    t.string  "city",           :limit => 100
    t.decimal "typeofshipping"
    t.decimal "discount"
    t.decimal "creditperiod"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                                              :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128,                                :default => ""
    t.string   "password_salt",                                                      :default => ""
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :precision => 38, :scale => 0, :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "i_users_reset_password_token", :unique => true

  create_table "workitems", :force => true do |t|
    t.integer  "worklist_id", :precision => 38, :scale => 0
    t.string   "item_type"
    t.integer  "ref_id",      :precision => 38, :scale => 0
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "worklists", :force => true do |t|
    t.string   "description"
    t.string   "status"
    t.datetime "open_date"
    t.datetime "close_date"
    t.string   "created_by"
    t.string   "list_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
