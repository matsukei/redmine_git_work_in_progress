require_dependency 'issue'

module GitWip
  module IssuePatch
    extend ActiveSupport::Concern

    included do
      safe_attributes 'git_wip_branch_attributes'

      has_one :git_wip_branch, autosave: true, dependent: :nullify, class_name: 'GitWip::Branch'
      accepts_nested_attributes_for :git_wip_branch
    end

  end
end

GitWip::IssuePatch.tap do |mod|
  Issue.send :include, mod unless Issue.include?(mod)
end
