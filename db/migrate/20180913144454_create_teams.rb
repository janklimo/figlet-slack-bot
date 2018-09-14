class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :external_id, null: false
      t.string :access_token, null: false
      t.string :bot_user_id, null: false
      t.string :bot_access_token, null: false
      t.timestamps null: false
    end

    add_index :teams, :external_id, unique: true
  end
end
