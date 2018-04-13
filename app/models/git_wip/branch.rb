class GitWip::Branch < ActiveRecord::Base
  self.table_name = 'git_wip_branches'

  belongs_to :repository
  belongs_to :issue

  # mkdir hogehoge
  # git --bare init --shared
  # git update-server-info

  # repository.default_branch
  #=> "master"

  # repository.diff(path, rev, rev_to)

end
