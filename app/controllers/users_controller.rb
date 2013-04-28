class UsersController < ApplicationController
  def index
    User.create(iidxid: "1111-1111", djname: "IKSTRM")
    ;
    @users = User.all
  end

  def create
    User.create(iidxid: params[:iidxid], djname: params[:djname])
    render text: "create succeeded"
  end
end
