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
    end

    it "should be success" do
      response.should be_success
    end

    it "should change power values" do
      @power = Power.find(iidxid: "1111-1111")
      (8..10).each do |level|
        symbol = "sp#{level}score".to_sym
        @power[symbol].should_not == nil
        symbol = "sp#{level}title".to_sym
        @power[symbol].should_not == nil
      end
    end
  end
end
