require_dependency 'repository'

module GitWip
  module RepositoryPatch
    extend ActiveSupport::Concern

    included do
      has_many :git_wip_branches, dependent: :nullify, class_name: 'GitWip::Branch'
    end

    def git?
      self.type == 'Repository::Git'
    end

    def no_merged_branches
      return nil unless self.git?

      return self.scm.no_merged_branches - self.ignore_branches
    end

    def ignore_branches
      self.git_wip_branches.no_merged.pluck(:compare_name)
    end

    def merge_base_identifier(base_branch, compare_branch)
      return nil unless self.git?

      base_identifier = self.latest_changeset_identifier(base_branch)
      compare_identifier = self.latest_changeset_identifier(compare_branch)

      return self.scm.merge_base_identifier(base_identifier, compare_identifier)
    end

    def latest_changeset_identifier(rev)
      self.class.changeset_identifier(self.latest_changesets('', rev, 1).first)
    end

    def no_merged_commits(base_branch, compare_branch)
      identifier_from = self.merge_base_identifier(base_branch, compare_branch)
      return [] if identifier_from.blank?

      base_revisions = self.scm.revisions('', identifier_from, base_branch)
      compare_revisions = self.scm.revisions('', identifier_from, compare_branch)
      return self.changesets.where(scmid: compare_revisions.map(&:scmid)).where.not(scmid: base_revisions.map(&:scmid))
    end

  end
end

GitWip::RepositoryPatch.tap do |mod|
  Repository.send :include, mod unless Repository.include?(mod)
end
