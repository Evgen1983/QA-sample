class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :score, default: 0
      t.integer :votable_id
      t.string :votable_type
      t.references :user, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps null: false
    end

    add_index :votes, [:user_id, :votable_id, :votable_type], unique:true
  end
end
