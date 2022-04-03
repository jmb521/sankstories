json.extract! book, :id, :type, :created_at, :updated_at
json.url book_url(book, format: :json)
