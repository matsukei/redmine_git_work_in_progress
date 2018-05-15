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

    def merge_base_identifier(base_identifier, compare_identifier)
      identifier = nil
      cmd_args = %w|show-branch --merge-base|
      cmd_args << base_identifier
      cmd_args << compare_identifier

      git_cmd(cmd_args) do |io|
        identifier = io.lines.map(&:chomp).first
      end

      identifier
    rescue Redmine::Scm::Adapters::AbstractAdapter::ScmCommandAborted
      nil
    end

    def git_cmd(args, options = {}, &block)
      repo_path = root_url || url
      full_args = ['--git-dir', repo_path] unless options[:remove_git_dir]
      if self.class.client_version_above?([1, 7, 2])
        full_args << '-c' << 'core.quotepath=false'
        full_args << '-c' << 'log.decorate=no'
      end
      full_args += args
      ret = shellout(
               self.class.sq_bin + ' ' + full_args.map { |e| shell_quote e.to_s }.join(' '),
               options,
               &block
               )
      if $? && $?.exitstatus != 0
        raise ScmCommandAborted, "git exited with non-zero status: #{$?.exitstatus}"
      end
      ret
    end
    private :git_cmd

  end
end

GitWip::GitAdapterPatch.tap do |mod|
  Redmine::Scm::Adapters::GitAdapter.send :include, mod unless Redmine::Scm::Adapters::GitAdapter.include?(mod)
end
