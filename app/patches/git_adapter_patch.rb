require_dependency 'redmine/scm/adapters/git_adapter'

module GitWip
  module GitAdapterPatch
    extend ActiveSupport::Concern

    def no_merged_branches
      brans = []
      cmd_args = %w|branch --no-color --verbose --no-abbrev --no-merged|
      git_cmd(cmd_args) do |io|
        io.each_line do |line|
          branch_rev = line.match('\s*(\*?)\s*(.*?)\s*([0-9a-f]{40}).*$')
          bran = Redmine::Scm::Adapters::GitAdapter::GitBranch.new(branch_rev[2])
          bran.revision = branch_rev[3]
          bran.scmid = branch_rev[3]
          bran.is_default = ( branch_rev[1] == '*' )
          brans << bran
        end
      end

      return brans.sort!
    rescue Redmine::Scm::Adapters::AbstractAdapter::ScmCommandAborted
      return []
    end

    def no_merged_diffs(base_branch, compare_branch)
      diffs = []
      cmd_args = %w|diff --no-color|
      cmd_args << base_branch
      cmd_args << compare_branch

      git_cmd(cmd_args) do |io|
        io.each_line do |line|
          diffs << line
        end
      end

      return diffs
    rescue Redmine::Scm::Adapters::AbstractAdapter::ScmCommandAborted
      return []
    end

    def merge_base_identifier(base_identifier, compare_identifier)
      identifier = nil
      cmd_args = %w|show-branch --merge-base|
      cmd_args << base_identifier
      cmd_args << compare_identifier

      git_cmd(cmd_args) do |io|
        identifier = io.lines.map(&:chomp).first
      end

      return identifier
    rescue Redmine::Scm::Adapters::AbstractAdapter::ScmCommandAborted
      return nil
    end

  end
end

GitWip::GitAdapterPatch.tap do |mod|
  Redmine::Scm::Adapters::GitAdapter.send :include, mod unless Redmine::Scm::Adapters::GitAdapter.include?(mod)
end
