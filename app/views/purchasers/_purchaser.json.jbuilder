json.extract! purchaser, :id, :first_name, :last_name, :email, :phone, :created_at, :updated_at
json.url purchaser_url(purchaser, format: :json)
