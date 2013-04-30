# -*- coding: utf-8 -*-
class Music
  def self.music_data_attributes
    [:title, :level, :playtype, :difficulty, :notes]
  end

  def self.music_args_attributes
    [:title, :playtype, :difficulty]
  end

  def self.add(args = {})
    return unless args[:level] && args[:title] && args[:playtype] && args[:difficulty] && args[:notes]
    add_to_level_set(args)
    update_music_data(args)
  end

  def self.where(args = {})
    return unless args[:playtype] && args[:level]
    array = $redis.smembers("#{args[:playtype]}:#{args[:level]}")
    array.map do |title|
      hash = Hash.new
      music_data_attributes.each do |symbol|
        hash[symbol] = $redis.hget("music_datas:" + title, symbol)
      end
      hash
    end
  end

  def self.find(args = {})
    hash = Hash.new
    music_data_attributes.each do |symbol|
      hash[symbol] = $redis.hget(hash_key(args), symbol)
    end
    hash
  end

  def self.add_to_level_set(args)
    # SADD SP:12 冥:SPA
    $redis.sadd("#{args[:playtype]}:#{args[:level]}", "#{args[:title]}:#{args[:playtype]+args[:difficulty]}")
  end

  def self.update_music_data(args)
    music_data_attributes.each do |symbol|
      $redis.hset(hash_key(args), symbol, args[symbol])
    end
  end

  def self.hash_key(args)
    music_args_attributes.each do |symbol|
      return "dummy" unless args[symbol]
    end
    "music_datas:#{args[:title]}:#{args[:playtype]+args[:difficulty]}" # music_data:冥:SPA
  end
end
