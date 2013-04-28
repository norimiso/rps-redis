# -*- coding: utf-8 -*-
require 'spec_helper'

describe Music do
  before(:all) do
    @redis = Redis.new(host: 'localhost', port: 6379);
    @redis.ping
  end

  before do
    @redis.flushall
  end

  describe ".add" do
    it "should add music to level set" do
      Music.add(level: "12", title: "冥", playtype: "SP", difficulty: "A", notes: "2000")
      $redis.smembers("SP:12").include?("冥:SPA").should == true
    end

    it "should update music data" do
      Music.add(level: "12", title: "冥", playtype: "SP", difficulty: "A", notes: "2000")
      $redis.hget("music_data:冥:SPA", :notes).should == "2000"
    end
  end

  describe ".where" do
    it "should return music data array" do
      $redis.sadd("SP:12", "冥:SPA")
      $redis.hset("music_data:冥:SPA", :notes, "2000")
      Music.where(playtype: "SP", level: "12").first[:notes].should == "2000"
    end
  end

  describe ".find" do
    it "should return music data hash" do
      $redis.sadd("SP:12", "冥:SPA")
      $redis.hset("music_data:冥:SPA", :notes, "2000")
      Music.find(title: "冥", playtype: "SP", difficulty: "A").should be_a_kind_of Hash
    end
  end
end
