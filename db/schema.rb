# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 30) do

  create_table "accessors", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "function_id"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors", :force => true do |t|
    t.string   "nickname"
    t.string   "prename"
    t.string   "lastname"
    t.string   "secret"
    t.date     "date_birth"
    t.integer  "gender",     :limit => 2,  :default => 0
    t.integer  "country",    :limit => 4
    t.text     "address"
    t.string   "zip",        :limit => 10
    t.string   "city"
    t.string   "email"
    t.string   "phone"
    t.string   "chat"
    t.text     "note"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "binaries", :force => true do |t|
    t.string   "title"
    t.string   "filename"
    t.string   "mime_type"
    t.integer  "size"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "div_tags", :force => true do |t|
    t.string   "name"
    t.text     "definition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.datetime "begins_at"
    t.datetime "ends_at"
    t.boolean  "open_end"
    t.text     "introduction"
    t.text     "body"
    t.integer  "picture_id"
    t.text     "picture_text"
    t.float    "price"
    t.float    "price_prebooking"
    t.float    "price_reduced"
    t.string   "location"
    t.string   "producer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_tickets",      :default => 450
    t.boolean  "promoted",         :default => true
  end

  create_table "functions", :force => true do |t|
    t.string   "name"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "galleries", :force => true do |t|
    t.string   "name"
    t.string   "path"
    t.text     "description"
    t.integer  "thumb_width"
    t.integer  "thumb_height"
    t.integer  "web_width"
    t.integer  "web_height"
    t.integer  "function_id"
    t.integer  "user_id"
    t.text     "options"
    t.integer  "div_tag_id"
    t.text     "div_extras"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", :force => true do |t|
    t.string   "logtype",    :default => "system"
    t.integer  "user_id"
    t.string   "ip"
    t.string   "entry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsletter_logs", :force => true do |t|
    t.integer  "newsletter_template_id"
    t.integer  "newsletter_subscription_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsletter_subscriptions", :force => true do |t|
    t.integer  "newsletter_id"
    t.string   "email"
    t.string   "subscripted_from"
    t.string   "handling_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "content_type",     :default => "text/html"
  end

  create_table "newsletter_templates", :force => true do |t|
    t.string   "subject"
    t.integer  "newsletter_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsletters", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.string   "from_address"
    t.text     "footer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public_subscribable", :default => true
    t.string   "default_type",        :default => "text/html"
  end

  create_table "page_columns", :force => true do |t|
    t.string   "title"
    t.integer  "page_id"
    t.integer  "position"
    t.integer  "div_tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "default_order", :default => "updated_at desc"
  end

  create_table "page_columns_postings", :id => false, :force => true do |t|
    t.integer "page_column_id"
    t.integer "posting_id"
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.text     "introduction"
    t.boolean  "show_title"
    t.boolean  "show_introduction"
    t.integer  "div_tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language",                :default => "en_US"
    t.boolean  "show_in_menu",            :default => true
    t.integer  "restrict_to_function_id"
  end

  create_table "postings", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "author_id"
    t.date     "date_expires"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                  :default => 1
    t.integer  "restricted_to_function_id"
    t.integer  "allow_editing",             :default => 0
    t.integer  "truncate_length",           :default => 512
  end

  create_table "tickets", :force => true do |t|
    t.integer  "event_id"
    t.string   "name"
    t.float    "price"
    t.string   "reservation_code"
    t.string   "email"
    t.integer  "num_tickets"
    t.text     "note"
    t.string   "telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "longname"
    t.string   "password"
    t.boolean  "locked",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "utok",              :default => "not logged in yet"
    t.string   "email"
    t.datetime "registered_at"
    t.datetime "confirmed_at"
    t.string   "confirmation_code"
    t.string   "confirmed_from_ip"
  end

end
