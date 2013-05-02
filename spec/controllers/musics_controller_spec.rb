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

  describe "#textage_music_data" do
    it "should get pink rose's notes" do
      musics_controller = MusicsController.new
      music_list = musics_controller.textage_music_list
      music_list.each do |music|
        if music[:title] == "Pink Rose"
          music = musics_controller.textage_music_data(music)
          music[:spa][:notes].should == "708"
        end
      end
    end
  end

  # Temporary disable because this is too slow to test
  # describe "POST 'musics/update'" do
  #   before(:all) do
  #     @redis = Redis.new(host: 'localhost', port: 6379);
  #     @redis.flushall
  #   end

  #   before do
  #     xhr :post, :update
  #   end

  #   it "should be success" do
  #     response.should be_success
  #   end

  #   it "should update music data" do
  #     @redis.smembers("SP:12").include?("冥:SPA").should == true
  #   end
  # end
end
