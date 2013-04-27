# -*- coding: utf-8 -*-
require 'spec_helper'

describe MusicsController do
  describe "GET 'musics'" do
    before do
      xhr :get, :index
    end

    it "should be success" do
      response.should be_success
    end
  end

  describe "POST 'musics/update'" do
    before(:all) do
      @redis = Redis.new(host: 'localhost', port: 6379);
      @redis.flushall
    end

    before do
      xhr :post, :update
    end

    it "should be success" do
      response.should be_success
    end

    it "should update music data" do
      @redis.smembers("SP:12").include?("冥").should == true
    end
  end
end
