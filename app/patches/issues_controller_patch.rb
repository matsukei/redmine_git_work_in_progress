require_dependency 'issues_controller'

module GitWip
  module IssuesControllerPatch
    extend ActiveSupport::Concern

    included do
      before_action :fetch_changesets, only: [ :show ]
    end

    def fetch_changesets
      @issue && @issue.git_wip_branch.try(:fetch_changesets)
    end
    private :fetch_changesets

  end
end

GitWip::IssuesControllerPatch.tap do |mod|
  IssuesController.send :include, mod unless IssuesController.include?(mod)
end
