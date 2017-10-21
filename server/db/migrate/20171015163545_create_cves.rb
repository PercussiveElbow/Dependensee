class CreateCves < ActiveRecord::Migration[5.1]
  def change
    create_table :cves, id: false ,:primary_key => :cve_id do |t|
      t.string :id, null: false
      t.string :dependency_name
      t.string :date
      t.string :desc
      t.string :cvss2
      t.text :patched_versions, array: true, default: []
      t.text :unaffected_versions, array: true, default: []

      t.timestamps
    end
    change_column :cves, :cve_id, :string
    remove_column :cves, :id
    execute "ALTER TABLE dcves ADD PRIMARY KEY (cve_id);"
  end
end
