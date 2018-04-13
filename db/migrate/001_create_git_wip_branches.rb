class CreateGitWipBranches < ActiveRecord::Migration
  def change
    create_table :git_wip_branches do |t|
      t.integer :repository_id
      t.integer :issue_id

      t.string :name
      t.boolean :merged
      t.boolean :reverted
      t.boolean :deleted

      t.timestamps
    end
  end
end
