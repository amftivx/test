class Tag < Sequel::Model
  def to_api
    { id: id, name: name, color: color }
  end
end
