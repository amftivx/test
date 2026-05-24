class ItemRepository
  def all
    Item.all
  end

  def find(id)
    Item.first(id: id)
  end

  def create(attrs)
    Item.create(name: attrs['name'], description: attrs['description'])
  end

  def update(id, attrs)
    item = find(id)
    return nil unless item
    item.update(name: attrs['name'], description: attrs['description'])
    item
  end

  def delete(id)
    item = find(id)
    return nil unless item
    item.destroy
    item
  end
end
