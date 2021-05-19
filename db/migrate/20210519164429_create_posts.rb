class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :name
      t.text :memo
      t.references :user

      t.timestamps
    end
  end
end