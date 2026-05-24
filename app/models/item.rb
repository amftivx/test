class Item < Sequel::Model
  def to_api
    { id: id, name: name, description: description }
  end
end
