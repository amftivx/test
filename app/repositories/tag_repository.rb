class TagRepository
  def all
    Tag.all
  end

  def find(id)
    Tag.first(id: id)
  end

  def create(attrs)
    Tag.create(name: attrs['name'], color: attrs['color'])
  end

  def update(id, attrs)
    tag = find(id)
    return nil unless tag
    tag.update(name: attrs['name'], color: attrs['color'])
    tag
  end

  def delete(id)
    tag = find(id)
    return nil unless tag
    tag.destroy
    tag
  end
end
