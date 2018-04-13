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
          bran.revision =  branch_rev[3]
          bran.scmid    =  branch_rev[3]
          bran.is_default = ( branch_rev[1] == '*' )
          brans << bran
        end
      end
      brans.sort!
    rescue Redmine::Scm::Adapters::AbstractAdapter::ScmCommandAborted
      nil
    end

    def no_fast_forward_merge
      # git merge --no-ff feature-branch
    end

    def destroy_branch(force = false)
      # git branch -d feature-branch
      # git branch --delete --force feature-branch
    end

    def conflict?
      # git merge feature-branch --no-commit
      # git merge --abort

      # git format-patch master  --stdout > test.patch
      # git checkout master
      # git apply test.patch --check
    end

  end
end

GitWip::GitAdapterPatch.tap do |mod|
  Redmine::Scm::Adapters::GitAdapter.send :include, mod unless Redmine::Scm::Adapters::GitAdapter.include?(mod)
end
