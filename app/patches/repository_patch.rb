require_dependency 'repository'

module GitWip
  module RepositoryPatch
    extend ActiveSupport::Concern

    included do
      has_many :git_wip_branches, dependent: :nullify, class_name: 'GitWip::Branch'
    end

    def no_merged_branches
      return nil unless self.type == 'Repository::Git'
      return self.scm.no_merged_branches
    end

  end
end

GitWip::RepositoryPatch.tap do |mod|
  Repository.send :include, mod unless Repository.include?(mod)
end
