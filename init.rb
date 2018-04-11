Redmine::Plugin.register :redmine_git_work_in_progress do
  name 'Redmine Git Work In Progress plugin'
  author 'Matsukei Co.,Ltd'
  description "This is a plugin that provides Reduine's Issue like `Work In Progress Pull Request` and makes it easy to share knowledge."
  version '1.0.0'
  requires_redmine version_or_higher: '3.2.0'
  url 'https://github.com/matsukei/redmine_git_work_in_progress'
  author_url 'http://www.matsukei.co.jp/'
end

require_relative 'lib/git_work_in_progress'
