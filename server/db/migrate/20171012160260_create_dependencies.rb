class CreateDependencies < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto'

    create_table :dependencies, id: :uuid do |t|
      t.string :name
      t.string :language
      t.string :version
      t.string :raw
      t.references :scan, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
