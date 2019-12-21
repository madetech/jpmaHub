Sequel.migration do
  change do
    create_table :tgif do
      primary_key :id
      String :team_name, null: false
      String :message, null: false
      Timestamp :time_stamp, null: false
    end
  end
end