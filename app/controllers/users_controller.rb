class UsersController < ApplicationController
  def index
    @users = User.all
    i = 0
    @users = @users.sort do |a, b|
      i += 1
      a_total = Power.find(iidxid: a[:iidxid])[:sptotal].to_i
      b_total = Power.find(iidxid: b[:iidxid])[:sptotal].to_i
      b_total <=> a_total
    end
  end

  def create
    User.create(iidxid: params[:iidxid], djname: params[:djname])
    render text: "create succeeded"
  end
end
