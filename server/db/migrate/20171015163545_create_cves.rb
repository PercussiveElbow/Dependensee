class CreateRubyCves < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto'
    create_table :ruby_cves, id: :uuid do |t|
      t.string :dependency_name
      t.string :date
      t.string :desc
      t.string :cvss2
      t.string :cve_id
      t.text :patched_versions, array: true, default: []
      t.text :unaffected_versions, array: true, default: []

      t.timestamps
    end
    # change_column :cves, :cve_id, :string
    # remove_column :cves, :id
    # execute "ALTER TABLE dcves ADD PRIMARY KEY (cve_id);"
  end
end
