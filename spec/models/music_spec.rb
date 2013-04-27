require 'spec_helper'

describe Music do
  before(:all) do
    @redis = Redis.new(:host => 'localhost', :port => 6379);
    @redis.ping
  end

  describe ".update" do
    before do
      @redis.flushall
    end

    context "user not already added" do
      it "should create user" do
        @redis.smembers("user").should_not include "1111-1111"
        User.create(iidxid: "1111-1111", djname: "test")
        @redis.smembers("user").should include "1111-1111"
        @redis.get("user:1111-1111").should == "test"
      end
    end

    context "user already added" do
      it "should update his djname" do
        @redis.sadd("user", "1111-1111")
        @redis.set("user:1111-1111", "test1")
        User.create(iidxid: "1111-1111", djname: "test2")
        @redis.get("user:1111-1111").should == "test2"
      end
    end
  end
end
