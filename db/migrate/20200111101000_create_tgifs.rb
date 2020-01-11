class CreateTgifs < ActiveRecord::Migration[6.0]
  def change
    create_table :tgifs do |t|
      t.string :team_name
      t.string :message
      t.string :slack_user_id
      t.timestamp :created_at
    end
  end
end
