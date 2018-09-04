class CreateIntercommunalities < ActiveRecord::Migration[5.0]
  def change
    create_table :intercommunalities do |t|
      t.string :name
      t.string :siren
      t.string :form
      t.string :slug

      t.timestamps
    end
  end
end
