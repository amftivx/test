Sequel.migration do
  up do
    create_table(:items) do
      primary_key :id
      String :name
      String :description
    end
  end

  down do
    drop_table(:items)
  end
end
