# NoFastForwardMerges
class MergeBranchesController < ApplicationController
  before_action :set_issue

  # merge: merge_branches POST /merge_branches(.:format)
  def create
    @issue.git_wip_branch.no_fast_forward_merge!
  rescue => e
  ensure
    redirect_to issue_path(@issue)
  end

  # revert: merge_branch DELETE /merge_branches/:id(.:format)
  def destroy
    @issue.git_wip_branch.no_fast_forward_merge!
  rescue => e
  ensure
    redirect_to issue_path(@issue)
  end

  private

    def set_issue
      @issue = Issue.find(params[:issue_id])
    end

end
