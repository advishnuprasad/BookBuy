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

ActiveRecord::Schema.define(:version => 20110719064359) do

  create_table "book_mig_log", :id => false, :force => true do |t|
    t.string    "book_no",    :limit => 20,                                :null => false
    t.integer   "branch_id",                :precision => 38, :scale => 0, :null => false
    t.timestamp "created_at", :limit => 6,                                 :null => false
    t.string    "status",     :limit => 1,                                 :null => false
    t.string    "msg",                                                     :null => false
  end

  create_table "bookreceipts", :force => true do |t|
    t.string    "book_no",                                                 :null => false
    t.string    "po_no",                                                   :null => false
    t.string    "invoice_no",                                              :null => false
    t.string    "isbn",                                                    :null => false
    t.integer   "title_id",                 :precision => 38, :scale => 0, :null => false
    t.timestamp "created_at",  :limit => 6
    t.timestamp "updated_at",  :limit => 6
    t.integer   "crate_id",                 :precision => 38, :scale => 0, :null => false
    t.integer   "created_by",               :precision => 38, :scale => 0
    t.integer   "modified_by",              :precision => 38, :scale => 0
    t.integer   "invoice_id",               :precision => 38, :scale => 0
    t.integer   "po_id",                    :precision => 38, :scale => 0
  end

  add_index "bookreceipts", ["book_no"], :name => "bookreceipts_uk1", :unique => true

  create_table "boxes", :force => true do |t|
    t.integer   "box_no",                  :precision => 38, :scale => 0, :null => false
    t.string    "po_no",                                                  :null => false
    t.string    "invoice_no",                                             :null => false
    t.integer   "total_cnt",               :precision => 38, :scale => 0
    t.timestamp "created_at", :limit => 6
    t.timestamp "updated_at", :limit => 6
    t.integer   "crate_id",                :precision => 38, :scale => 0
  end

  create_table "corelist", :force => true do |t|
    t.string  "isbn",          :limit => 30,                                 :null => false
    t.string  "title"
    t.string  "author"
    t.string  "publisher"
    t.integer "publishercode",                :precision => 38, :scale => 0
    t.decimal "price"
    t.string  "currency",      :limit => 30
    t.string  "category"
    t.string  "subcategory"
    t.integer "qty",                          :precision => 38, :scale => 0
    t.decimal "branchid"
    t.integer "key_id",        :limit => nil
  end

  create_table "crates", :force => true do |t|
    t.integer   "total_cnt",                :precision => 38, :scale => 0
    t.timestamp "created_at",  :limit => 6
    t.timestamp "updated_at",  :limit => 6
    t.integer   "created_by",               :precision => 38, :scale => 0
    t.integer   "modified_by",              :precision => 38, :scale => 0
  end

  create_table "csv_stages", :force => true do |t|
    t.integer   "invoice_id",                  :precision => 38, :scale => 0
    t.integer   "quantity",                    :precision => 38, :scale => 0
    t.string    "author"
    t.string    "title"
    t.string    "isbn"
    t.string    "publisher"
    t.string    "currency"
    t.decimal   "unit_price"
    t.decimal   "unit_price_inr"
    t.decimal   "conv_rate"
    t.decimal   "discount"
    t.decimal   "net_amount"
    t.integer   "user_id",                     :precision => 38, :scale => 0
    t.string    "error"
    t.timestamp "created_at",     :limit => 6
    t.timestamp "updated_at",     :limit => 6
  end

  create_table "currencies", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "created_by",  :precision => 38, :scale => 0
    t.integer  "modified_by", :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "currencies", ["code"], :name => "index_currencies_on_code", :unique => true

  create_table "currencyrates", :force => true do |t|
    t.string   "code1"
    t.string   "code2"
    t.decimal  "rate"
    t.datetime "effective_from"
    t.integer  "created_by",     :precision => 38, :scale => 0
    t.integer  "modified_by",    :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "distributions", :force => true do |t|
    t.integer  "procurementitem_id", :precision => 38, :scale => 0
    t.integer  "branch_id",          :precision => 38, :scale => 0
    t.integer  "quantity",           :precision => 38, :scale => 0
    t.integer  "procured_cnt",       :precision => 38, :scale => 0
    t.integer  "created_by",         :precision => 38, :scale => 0
    t.integer  "modified_by",        :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrichedtitle_versions", :force => true do |t|
    t.integer   "enrichedtitle_id",              :precision => 38, :scale => 0
    t.integer   "version",                       :precision => 38, :scale => 0
    t.integer   "title_id",                      :precision => 38, :scale => 0
    t.string    "title"
    t.string    "isbn"
    t.string    "language"
    t.string    "category"
    t.string    "subcategory"
    t.string    "isbn10"
    t.timestamp "created_at",       :limit => 6
    t.timestamp "updated_at",       :limit => 6
    t.string    "verified"
    t.string    "author"
    t.string    "isbnvalid"
    t.integer   "listprice",                     :precision => 38, :scale => 0
    t.string    "currency"
    t.string    "enriched"
    t.integer   "imprint_id",                    :precision => 38, :scale => 0
  end

  add_index "enrichedtitle_versions", ["enrichedtitle_id"], :name => "i_enr_ver_enr_id"

  create_table "enrichedtitles", :force => true do |t|
    t.integer   "title_id",                 :precision => 38, :scale => 0
    t.string    "title",                                                   :null => false
    t.string    "isbn",                                                    :null => false
    t.string    "language"
    t.string    "category"
    t.string    "subcategory"
    t.string    "isbn10"
    t.timestamp "created_at",  :limit => 6
    t.timestamp "updated_at",  :limit => 6
    t.integer   "version",                  :precision => 38, :scale => 0
    t.string    "verified"
    t.string    "author"
    t.string    "isbnvalid"
    t.decimal   "listprice",                                               :null => false
    t.string    "currency",                                                :null => false
    t.string    "enriched"
    t.integer   "imprint_id",               :precision => 38, :scale => 0
  end

  add_index "enrichedtitles", ["isbn"], :name => "enrichedtitles_isbn", :unique => true

  create_table "imprints", :force => true do |t|
    t.string    "code",                                                     :null => false
    t.string    "name"
    t.timestamp "created_at",   :limit => 6
    t.timestamp "updated_at",   :limit => 6
    t.integer   "publisher_id",              :precision => 38, :scale => 0
  end

  create_table "invoiceitems", :force => true do |t|
    t.integer   "invoice_id",                  :precision => 38, :scale => 0, :null => false
    t.integer   "quantity",                    :precision => 38, :scale => 0
    t.string    "author"
    t.string    "title"
    t.string    "isbn"
    t.string    "publisher"
    t.string    "currency"
    t.decimal   "unit_price"
    t.decimal   "unit_price_inr"
    t.decimal   "conv_rate"
    t.decimal   "discount"
    t.decimal   "net_amount"
    t.integer   "user_id",                     :precision => 38, :scale => 0
    t.timestamp "created_at",     :limit => 6
    t.timestamp "updated_at",     :limit => 6
  end

  create_table "invoices", :force => true do |t|
    t.string    "invoice_no",                                                  :null => false
    t.integer   "po_id",                        :precision => 38, :scale => 0, :null => false
    t.timestamp "date_of_receipt", :limit => 6,                                :null => false
    t.integer   "quantity",                     :precision => 38, :scale => 0, :null => false
    t.decimal   "amount",                                                      :null => false
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
    t.integer   "boxes_cnt",                    :precision => 38, :scale => 0, :null => false
    t.timestamp "date_of_invoice", :limit => 6,                                :null => false
    t.integer   "created_by",                   :precision => 38, :scale => 0
    t.integer   "modified_by",                  :precision => 38, :scale => 0
  end

  add_index "invoices", ["invoice_no", "po_id"], :name => "invoices_unq", :unique => true

  create_table "list_stagings", :force => true do |t|
    t.string    "isbn"
    t.string    "title"
    t.string    "author"
    t.string    "publisher"
    t.string    "publisher_id"
    t.integer   "quantity",                  :precision => 38, :scale => 0
    t.decimal   "listprice"
    t.string    "currency"
    t.string    "category"
    t.string    "subcategory"
    t.integer   "branch_id",                 :precision => 38, :scale => 0
    t.string    "error"
    t.timestamp "created_at",   :limit => 6
    t.timestamp "updated_at",   :limit => 6
    t.integer   "list_id",                   :precision => 38, :scale => 0
    t.integer   "created_by",                :precision => 38, :scale => 0
  end

  create_table "listitems", :force => true do |t|
    t.string    "isbn",                                                     :null => false
    t.string    "title",                                                    :null => false
    t.string    "author"
    t.string    "publisher",                                                :null => false
    t.integer   "publisher_id",              :precision => 38, :scale => 0, :null => false
    t.integer   "quantity",                  :precision => 38, :scale => 0
    t.decimal   "listprice",                                                :null => false
    t.string    "currency",                                                 :null => false
    t.string    "category"
    t.string    "subcategory"
    t.integer   "branch_id",                 :precision => 38, :scale => 0
    t.integer   "created_by",                :precision => 38, :scale => 0
    t.integer   "modified_by",               :precision => 38, :scale => 0
    t.timestamp "created_at",   :limit => 6
    t.timestamp "updated_at",   :limit => 6
    t.string    "error"
    t.string    "pulled"
    t.integer   "list_id",                   :precision => 38, :scale => 0, :null => false
  end

  create_table "lists", :force => true do |t|
    t.string    "name",                                                       :null => false
    t.string    "kind",                                                       :null => false
    t.integer   "key",                         :precision => 38, :scale => 0
    t.string    "pulled"
    t.integer   "created_by",                  :precision => 38, :scale => 0
    t.integer   "modified_by",                 :precision => 38, :scale => 0
    t.timestamp "created_at",  :limit => 6
    t.timestamp "updated_at",  :limit => 6
    t.string    "description", :limit => 1020,                                :null => false
  end

  create_table "newarrivals_expanded", :force => true do |t|
    t.string  "isbn",          :limit => 30,                                 :null => false
    t.string  "title"
    t.string  "author"
    t.string  "publisher"
    t.integer "publishercode",                :precision => 38, :scale => 0
    t.decimal "price"
    t.string  "currency",      :limit => 30
    t.string  "category"
    t.string  "subcategory"
    t.integer "qty",                          :precision => 38, :scale => 0
    t.integer "branchid",                     :precision => 38, :scale => 0
    t.integer "key_id",        :limit => nil
  end

  create_table "pos", :force => true do |t|
    t.string    "code",                                                          :null => false
    t.integer   "supplier_id",                    :precision => 38, :scale => 0, :null => false
    t.integer   "branch_id",                      :precision => 38, :scale => 0
    t.timestamp "raised_on",      :limit => 6
    t.integer   "titles_cnt",                     :precision => 38, :scale => 0
    t.integer   "copies_cnt",                     :precision => 38, :scale => 0
    t.string    "status"
    t.string    "user"
    t.timestamp "created_at",     :limit => 6
    t.timestamp "updated_at",     :limit => 6
    t.decimal   "discount"
    t.integer   "publisher_id",   :limit => nil
    t.string    "typeofpo"
    t.decimal   "convrate"
    t.decimal   "grossamt"
    t.decimal   "netamt"
    t.decimal   "orgunit"
    t.decimal   "suborgunit"
    t.decimal   "expensehead"
    t.timestamp "payby1",         :limit => 6
    t.decimal   "payableamt1"
    t.timestamp "payby2",         :limit => 6
    t.decimal   "payableamt2"
    t.timestamp "payby3",         :limit => 6
    t.decimal   "payableamt3"
    t.string    "narration"
    t.integer   "invoices_count",                 :precision => 38, :scale => 0
    t.string    "currency",       :limit => 1020
    t.integer   "procurement_id",                 :precision => 38, :scale => 0
  end

  add_index "pos", ["code"], :name => "pos_code_idx", :unique => true

  create_table "procurementitems", :force => true do |t|
    t.string    "source"
    t.integer   "source_id",                        :precision => 38, :scale => 0
    t.integer   "enrichedtitle_id",                 :precision => 38, :scale => 0
    t.string    "isbn"
    t.string    "status"
    t.string    "po_number"
    t.string    "cancel_reason"
    t.integer   "deferred_by",                      :precision => 38, :scale => 0
    t.timestamp "last_action_date", :limit => 6
    t.integer   "supplier_id",                      :precision => 38, :scale => 0
    t.timestamp "expiry_date",      :limit => 6
    t.integer   "member_id",                        :precision => 38, :scale => 0
    t.string    "card_id"
    t.integer   "branch_id",                        :precision => 38, :scale => 0,                :null => false
    t.timestamp "created_at",       :limit => 6
    t.timestamp "updated_at",       :limit => 6
    t.integer   "quantity",                         :precision => 38, :scale => 0
    t.integer   "procured_cnt",                     :precision => 38, :scale => 0, :default => 0
    t.string    "availability",     :limit => 1020
    t.integer   "title_id",                         :precision => 38, :scale => 0
    t.integer   "procurement_id",                   :precision => 38, :scale => 0
    t.integer   "received_cnt",                     :precision => 38, :scale => 0
  end

  add_index "procurementitems", ["po_number", "isbn", "branch_id"], :name => "unq_po_isbn", :unique => true

  create_table "procurements", :force => true do |t|
    t.integer   "source_id",                 :precision => 38, :scale => 0
    t.string    "description"
    t.integer   "requests_cnt",              :precision => 38, :scale => 0
    t.integer   "created_by",                :precision => 38, :scale => 0
    t.integer   "modified_by",               :precision => 38, :scale => 0
    t.timestamp "created_at",   :limit => 6
    t.timestamp "updated_at",   :limit => 6
    t.string    "status"
  end

  create_table "publishers", :force => true do |t|
    t.timestamp "created_at", :limit => 6
    t.timestamp "updated_at", :limit => 6
    t.string    "name",       :limit => 1020, :null => false
    t.string    "country",    :limit => 1020
  end

  create_table "supplierdiscounts", :force => true do |t|
    t.integer   "publisher_id",              :precision => 38, :scale => 0, :null => false
    t.integer   "supplier_id",               :precision => 38, :scale => 0, :null => false
    t.decimal   "discount"
    t.timestamp "created_at",   :limit => 6
    t.timestamp "updated_at",   :limit => 6
    t.decimal   "bulkdiscount"
  end

  add_index "supplierdiscounts", ["publisher_id", "supplier_id"], :name => "supplierdiscounts_uk1", :unique => true

  create_table "suppliers", :id => false, :force => true do |t|
    t.integer  "id",                             :precision => 38, :scale => 0, :null => false
    t.string   "name",           :limit => 100,                                 :null => false
    t.string   "contact",        :limit => 100
    t.string   "phone",          :limit => 100
    t.string   "city",           :limit => 100
    t.integer  "typeofshipping",                 :precision => 38, :scale => 0
    t.integer  "discount",                       :precision => 38, :scale => 0
    t.integer  "creditperiod",                   :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",          :limit => 1020
  end

  create_table "title_mig_log", :primary_key => "title_id", :force => true do |t|
    t.timestamp "created_at", :limit => 6, :null => false
    t.string    "status",     :limit => 1, :null => false
    t.string    "msg",                     :null => false
  end

  create_table "titlereceipts", :force => true do |t|
    t.string    "po_no",                                                     :null => false
    t.string    "invoice_no",                                                :null => false
    t.string    "isbn",                                                      :null => false
    t.integer   "box_no",                     :precision => 38, :scale => 0, :null => false
    t.timestamp "created_at", :limit => 6
    t.timestamp "updated_at", :limit => 6
    t.string    "book_no",    :limit => 1020
    t.integer   "created_by",                 :precision => 38, :scale => 0
    t.string    "error",      :limit => 1020
  end

  create_table "workitems", :force => true do |t|
    t.integer   "worklist_id",              :precision => 38, :scale => 0, :null => false
    t.string    "item_type"
    t.integer   "ref_id",                   :precision => 38, :scale => 0
    t.string    "status"
    t.timestamp "created_at",  :limit => 6
    t.timestamp "updated_at",  :limit => 6
  end

  create_table "worklists", :force => true do |t|
    t.string    "description"
    t.string    "status"
    t.timestamp "open_date",      :limit => 6
    t.timestamp "close_date",     :limit => 6
    t.string    "created_by"
    t.string    "list_type"
    t.timestamp "created_at",     :limit => 6
    t.timestamp "updated_at",     :limit => 6
    t.integer   "procurement_id",              :precision => 38, :scale => 0
  end

  add_foreign_key "invoiceitems", "invoices", :name => "invoiceitems_invoices_fk1", :dependent => :delete

  add_foreign_key "list_stagings", "lists", :name => "list_stagings_lists_fk1", :dependent => :delete

  add_foreign_key "listitems", "lists", :name => "listitems_lists_fk1", :dependent => :delete

  add_foreign_key "workitems", "worklists", :name => "workitems_worklists_fk1", :dependent => :delete

  add_synonym "authentications", "authentications@link_opac", :force => true
  add_synonym "users", "users@link_opac", :force => true
  add_synonym "users_seq", "users_seq@link_opac", :force => true

end
