# -*- coding: utf-8 -*-
require 'spec_helper'

describe Score do
  before(:all) do
    @redis = Redis.new(host: 'localhost', port: 6379);
    @redis.ping
  end

  describe "#update" do
    before do
      @redis.flushall
    end

    context "when score doesn't exist" do
      it "should create score" do
        @score = Score.new(iidxid: "1111-1111", music: "冥", playtype: "SP", difficulty: "A")
        @score.update(exscore: "3000", bp: "10", clear: "EH")
        @redis.hget("score:1111-1111:冥:SP:A", :exscore).should == "3000"
        @redis.hget("score:1111-1111:冥:SP:A", :bp     ).should == "10"
        @redis.hget("score:1111-1111:冥:SP:A", :clear  ).should == "EH"
      end
    end

    context "when score exists" do
      it "should update score" do
        @redis.hset("score:1111-1111:冥:SP:A", :exscore, "2000")
        @redis.hset("score:1111-1111:冥:SP:A", :rate   , "50.0")
        @score = Score.new(iidxid: "1111-1111", music: "冥", playtype: "SP", difficulty: "A")
        @score.update(exscore: "4000", rate: "100.0")
        @redis.hget("score:1111-1111:冥:SP:A", :exscore).should == "4000"
        @redis.hget("score:1111-1111:冥:SP:A", :rate   ).should == "100.0"
      end
    end
  end
end
