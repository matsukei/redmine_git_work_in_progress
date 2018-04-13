module GitWip
  class IssueFromBottomViewHook < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_bottom, partial: 'branch'
  end
end
