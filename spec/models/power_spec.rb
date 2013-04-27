# -*- coding: utf-8 -*-
require 'spec_helper'

describe Power do
  before(:all) do
    @redis = Redis.new(host: 'localhost', port: 6379);
    @redis.ping
  end

  before do
    @redis.flushall
  end

  describe ".update" do
    it "should save power value" do
      Power.update(iidxid: "1111-1111", sp12s: "1000", sp11c: "2000")
      @redis.get("power:1111-1111:sp12s").should == "1000"
      @redis.get("power:1111-1111:sp11c").should == "2000"
    end
  end

  describe ".find" do
    it "should return power hash" do
      Power.update(iidxid: "1111-1111", sp12s: "1000", sp11c: "2000")
      @power = Power.find(iidxid: "1111-1111")
      @power.should be_a_kind_of(Hash)
      @power[:sp12s].should == "1000"
      @power[:sp11c].should == "2000"
    end
  end
end
