class GitWip::Branch < ActiveRecord::Base
  self.table_name = 'git_wip_branches'

  belongs_to :repository
  belongs_to :issue

  scope :no_merged, -> { where.not(id: 9999999) }

  def active?
    return self.repository.present? && self.base_name.present? && self.compare_name.present?
  end

  def fetch_changesets
    return unless self.active?

    commits = self.repository.no_merged_commits(self.base_name, self.compare_name)
    commits.each do |commit|
      i = commit.find_referenced_issue_by_id(self.issue_id)
      commit.issues << i if i && i.visible? && !commit.issues.include?(i)
    end
  end

  def no_merged_diffs
    return unless self.active?

    self.repository.no_merged_diffs(self.base_name, self.compare_name)
  end

  # TODO
  def mergeable?
    true
  end

  # TODO
  def revertable?
    true
  end

end
