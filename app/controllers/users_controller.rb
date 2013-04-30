class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    User.create(iidxid: params[:iidxid], djname: params[:djname])
    render text: "create succeeded"
  end
end
