# -*- coding: utf-8 -*-
require 'spec_helper'

describe UsersController do
  describe "GET root" do
    before do
      xhr :post, :index
    end

    it "should be success" do
      response.should be_success
    end
  end

  describe "POST 'users/create'" do
    before(:all) do
      @redis = Redis.new(host: 'localhost', port: 6379);
      @redis.flushall
    end

    before do
      xhr :post, :create, iidxid: "1111-1111", djname: "test"
    end

    it "should be success" do
      response.should be_success
    end

    it "should create user" do
      @redis.smembers("users").include?("1111-1111").should == true
      @redis.hget("users:1111-1111", :djname).should == "test"
    end
  end
end
