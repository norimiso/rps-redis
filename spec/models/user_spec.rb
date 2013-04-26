require 'spec_helper'

describe User do
  before(:all) do
    @redis = Redis.new(:host => 'localhost', :port => 6379);
    @redis.ping
  end

  describe ".create" do
    before do
      @redis.flushall
    end

    context "user not already added" do
      it "should create user" do
        @redis.smembers("user").should_not include "1111-1111"
        User.create("1111-1111")
        @redis.smembers("user").should include "1111-1111"
      end
    end

    context "user already added" do
      it "should do nothing" do
        @redis.sadd("user", "1111-1111")
        User.create("1111-1111")
        @redis.smembers("user").should include "1111-1111"
      end
    end
  end
end
