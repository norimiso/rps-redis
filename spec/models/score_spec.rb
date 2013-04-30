# -*- coding: utf-8 -*-
require 'spec_helper'

describe Score do
  before(:all) do
    @redis = Redis.new(host: 'localhost', port: 6379);
    @redis.ping
  end

  before do
    @redis.flushall
  end

  describe "#update" do

    context "when score doesn't exist" do
      it "should create score" do
        @score = Score.new(iidxid: "1111-1111", title: "冥", playtype: "SP", difficulty: "A")
        @score.update(exscore: "3000", bp: "10", clear: "EH")
        @redis.hget("scores:1111-1111:冥:SPA", :exscore).should == "3000"
        @redis.hget("scores:1111-1111:冥:SPA", :bp     ).should == "10"
        @redis.hget("scores:1111-1111:冥:SPA", :clear  ).should == "EH"
      end
    end

    context "when score exists" do
      it "should update score" do
        @redis.hset("scores:1111-1111:冥:SPA", :exscore, "2000")
        @redis.hset("scores:1111-1111:冥:SPA", :rate   , "50.0")
        @score = Score.new(iidxid: "1111-1111", title: "冥", playtype: "SP", difficulty: "A")
        @score.update(exscore: "4000", rate: "100.0")
        @redis.hget("scores:1111-1111:冥:SPA", :exscore).should == "4000"
        @redis.hget("scores:1111-1111:冥:SPA", :rate   ).should == "100.0"
      end
    end
  end

  describe ".where" do
    it "should return score hash" do
      @score = Score.new(iidxid: "1111-1111", title: "冥", playtype: "SP", difficulty: "A")
      @score.update(exscore: "3000", bp: "10", clear: "EH")
      hash = Score.where(iidxid: "1111-1111", title: "冥", playtype: "SP", difficulty: "A")
      hash.should be_a_kind_of Hash
      hash[:exscore].should == "3000"
    end
  end
end
