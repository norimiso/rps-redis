require 'spec_helper'

describe User do
  before(:all) do
    @redis = Redis.new(host: 'localhost', port: 6379);
    @redis.ping
  end

  describe ".all" do
    it "should return array" do
      User.create(iidxid: "1111-1111", djname: "test")
      @users = User.all
      @users.should be_a_kind_of Array
      @users.length.should > 0
    end
  end

  describe ".create" do
    before do
      @redis.flushall
    end

    context "user not already added" do
      it "should create user" do
        User.create(iidxid: "1111-1111", djname: "test")
        @redis.smembers("user").should include "1111-1111"
        @redis.hget("user:1111-1111", :djname).should == "test"
      end
    end

    context "user already added" do
      it "should update his djname" do
        @redis.sadd("user", "1111-1111")
        @redis.hset("user:1111-1111", :djname, "test1")
        User.create(iidxid: "1111-1111", djname: "test2")
        @redis.hget("user:1111-1111", :djname).should == "test2"
      end
    end
  end
end
