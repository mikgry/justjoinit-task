class CreateAnnouncements < ActiveRecord::Migration[6.1]
  def change
    create_table :announcements do |t|
      t.string :title, null: :false
      t.text :description, null: :false
      t.integer :price_cents, null: :false

      t.timestamps
    end
  end
end
