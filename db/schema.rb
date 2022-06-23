# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_05_17_005518) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "addr_type"
    t.integer "order_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "book_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "isbn"
    t.float "price"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "purchaser_id", null: false
    t.string "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.float "shipping_cost"
    t.string "shipping_method"
    t.index ["book_id"], name: "index_orders_on_book_id"
    t.index ["purchaser_id"], name: "index_orders_on_purchaser_id"
  end

  create_table "purchasers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "customer_id"
  end

  add_foreign_key "orders", "books"
  add_foreign_key "orders", "purchasers"
end
