module GitWip
  class IssueViewHook < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_bottom, partial: 'form_branch'
    render_on :view_issues_show_description_bottom, partial: 'show_branch'
  end
end
