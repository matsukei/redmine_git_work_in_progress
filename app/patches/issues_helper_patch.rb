require_dependency 'issues_helper'

module GitWip
  module IssuesHelperPatch
    extend ActiveSupport::Concern

    included do

      def issue_history_tabs(issue, journals)
        tabs = []

        tabs << { name: 'notes', label: :description_notes, partial: 'issues/journals', issue: issue, journals: journals }
        if issue.git_wip_branch.present?
          tabs << issue_commits_tab(issue)
          tabs << issue_changed_files_tab(issue)
        end
        tabs << { name: 'properties', label: :label_change_properties, partial: 'issues/journals', issue: issue, journals: journals }

        return tabs
      end

      def issue_commits_tab(issue)
        branch = issue.git_wip_branch
        commits = {}

        { name: 'commits', label: :label_revision_plural, partial: 'issues/commits', issue: issue, commits: commits }
      end

      def issue_changed_files_tab(issue)
        branch = issue.git_wip_branch
        changed_files = {}

        { name: 'changed_files', label: :label_diff, partial: 'issues/changed_files', issue: issue, changed_files: changed_files }
      end

      def skip_render_journal?(issue, journal, tab_name)
        return true if tab_name == 'notes' && journal.notes.blank?
        return true if tab_name == 'properties' && journal.details.blank?

        return false
      end

    end

  end
end

GitWip::IssuesHelperPatch.tap do |mod|
  IssuesHelper.send :include, mod unless IssuesHelper.include?(mod)
end
