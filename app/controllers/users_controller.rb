class UsersController < ApplicationController
  def index
    User.create(iidxid: "1234-1234", djname: "a")
    @users = User.all
  end

  def create
    User.create(iidxid: params[:iidxid], djname: params[:djname])
    render text: "create succeeded"
  end
end
