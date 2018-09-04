class CommuneStreets < ActiveRecord::Migration[5.0]
  def change
    create_join_table :communes, :streets do |t|
      t.index :commune_id
      t.index :street_id
    end
  end
end
