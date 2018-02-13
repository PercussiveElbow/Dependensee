class CreateScans < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto'
    create_table :scans, id: :uuid do |t|
      t.string :date
      t.string :source
      t.references :project, foreign_key: true, type: :uuid
      # t.references :dependency, foreign_key: true
      t.string :needs_update

      t.timestamps
    end
  end
end
