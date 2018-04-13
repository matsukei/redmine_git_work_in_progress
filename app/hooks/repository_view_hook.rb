module GitWip
  class RepositoryViewHook < Redmine::Hook::ViewListener
    render_on :view_repositories_show_contextual, partial: 'branch_list'
  end
end
