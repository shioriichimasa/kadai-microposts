class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :micropost, null: false, foreign_key: true

      t.timestamps
      # user_idとmicropost_idの重複防止
      t.index [:user_id, :micropost_id], unique: true
    end
  end
end
