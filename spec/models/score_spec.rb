# -*- coding: utf-8 -*-
require 'spec_helper'

describe Score do
  before(:all) do
    @redis = Redis.new(host: 'localhost', port: 6379);
    @redis.ping
  end

  describe ".update" do
    before do
      @redis.flushall
    end

    context "when score doesn't exist" do
      it "should create score" do
        Score.update(iidxid: "1111-1111", music: "冥", difficulty: "SPA", exscore: "3000", bp: "10", clear: "EH")
        @redis.hget("score:1111-1111:冥:SPA", :exscore).should == "3000"
        @redis.hget("score:1111-1111:冥:SPA", :bp).should == "10"
        @redis.hget("score:1111-1111:冥:SPA", :clear).should == "10"
      end
    end

    context "when score exists" do
      it "should update score" do
        @redis.set("score:1111-1111:冥:SPA", "2000")
        Score.update(iidxid: "1111-1111", music: "冥", difficulty: "SPA", value: "4000")
        @redis.get("score:1111-1111:冥:SPA").should == "4000"
      end
    end
  end
end
