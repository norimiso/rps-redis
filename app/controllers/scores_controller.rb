# -*- coding: utf-8 -*-
class ScoresController < ApplicationController
  def show
    User.create(iidxid: "1111-1111", djname: "IKSTRM")
    @score = Score.new(iidxid: "1111-1111", title: "冥", playtype: "SP", difficulty: "A")
    @score.update(exscore: "2344", bp: "10", clear: "EH")
    ;
    @user = User.find(iidxid: params[:iidxid])
    redirect_to root_url if @user == nil
    @musics = Hash.new
    ["SP", "DP"].each do |playtype|
      @musics[playtype] = Hash.new
      (1..12).each do |level|
        @musics[playtype][level] = Music.where(playtype: playtype, level: level)
          .map { |music| Score.where(iidxid: params[:iidxid], title: music[:title], playtype: playtype, difficulty: music[:difficulty]) }
        @musics[playtype][level].sort! { |a, b| b[:exscore].to_i <=> a[:exscore].to_i }
      end
    end
  end

  def update
    args = Hash.new
    [:iidxid, :title, :playtype, :difficulty].each do |symbol|
      args[symbol] = params[symbol.to_s]
    end
    @score = Score.new(args)
    @score.update(exscore: params["exscore"], bp: params["bp"], clear: params["clear"])
    render text: "update succeeded"
  end
end
