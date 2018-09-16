class RemoveBots < ActiveRecord::Migration[5.2]
  def change
    remove_column :teams, :bot_user_id
    remove_column :teams, :bot_access_token
  end
end
