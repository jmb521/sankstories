json.extract! order, :id, :book_id, :purchaser_id, :quantity, :created_at, :updated_at
json.url order_url(order, format: :json)
