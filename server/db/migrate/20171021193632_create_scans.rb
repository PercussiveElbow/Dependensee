class CreateScans < ActiveRecord::Migration[5.1]
  def change
    create_table :scans do |t|
      t.string :date
      t.string :source
      t.references :project, foreign_key: true
      # t.references :dependency, foreign_key: true

      t.timestamps
    end
  end
end
