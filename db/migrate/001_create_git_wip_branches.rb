class CreateGitWipBranches < ActiveRecord::Migration
  def change
    create_table :git_wip_branches do |t|
      t.integer :repository_id
      t.integer :issue_id

      t.boolean :merged
      t.boolean :reverted
      t.boolean :deleted

      t.string :base_name
      t.string :compare_name

      t.timestamps
    end
  end
end
