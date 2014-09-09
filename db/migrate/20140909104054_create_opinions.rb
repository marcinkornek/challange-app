class CreateOpinions < ActiveRecord::Migration
  def change
    create_table :opinions do |t|
      t.integer :opinion
      t.belongs_to :opinionable, polymorphic: true
      t.integer :user_id

      t.timestamps
    end
    add_index :opinions,  [:opinionable_id, :opinionable_type]
    add_index :opinions,  [:opinionable_id, :opinionable_type, :user_id], unique: true, name: 'index_opinions_on_op_id_and_op_type_and_user_id'
    add_index :opinions,   :user_id
  end
end
