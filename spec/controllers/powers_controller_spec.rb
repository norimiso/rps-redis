# -*- coding: utf-8 -*-
require 'spec_helper'

describe PowersController do
  describe "POST 'scores/update'" do
    before do
      @redis = Redis.new(host: 'localhost', port: 6379)
      @redis.flushall
      User.create(iidxid: "1111-1111", djname: "test")
      @score = Score.new(iidxid: "1111-1111", title: "冥", playtype: "SP", difficulty: "A")
      @score.update(exscore: "3000", bp: "10", clear: "EH")
      xhr :post, :update, iidxid: "1111-1111"
    end

    it "should be success" do
      response.should be_success
    end

    it "should change power values" do
      @power = Power.find(iidxid: "1111-1111")
      @power[:sp8s ].should_not == nil
      @power[:sp9s ].should_not == nil
      @power[:sp10s].should_not == nil
      @power[:sp11s].should_not == nil
      @power[:sp12s].should_not == nil
      @power[:sps  ].should_not == nil
      @power[:sp11c].should_not == nil
      @power[:sp12c].should_not == nil
      @power[:spc  ].should_not == nil
    end
  end
end
