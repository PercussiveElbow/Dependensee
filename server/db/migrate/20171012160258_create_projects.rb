class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto'

    create_table :projects, id: :uuid do |t|
      t.string :name
      t.boolean :auto_update, default: false
      t.boolean :auto_scan, default: false
      t.string :language
      t.string :owner
      t.string :description
      t.integer :timeout, default: 3600
      # t.references :scan, foreign_key: true

      t.timestamps
    end
  end
end
