class CreateJavaCves < ActiveRecord::Migration[5.1]
  def change
    create_table :java_cves, id: :uuid do |t|
      t.string :title
      t.string :date
      t.string :desc
      t.string :cvss2
      t.string :cve_id
      t.text :references
      t.text :affected

      t.timestamps
    end
  end
end
