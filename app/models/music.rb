# -*- coding: utf-8 -*-
class Music
  def self.add(args = {})
    return unless args[:level] && args[:title] && args[:playtype] && args[:difficulty] && args[:notes]
    add_to_level_set(args)
    update_music_data(args)
  end

  def self.add_to_level_set(args)
    # SADD SP:12 冥:SPA
    $redis.sadd("#{args[:playtype]}:#{args[:level]}", "#{args[:title]}:#{args[:playtype]+args[:difficulty]}")
  end

  def self.update_music_data(args)
    hash_key = "music_data:#{args[:title]}:#{args[:playtype]+args[:difficulty]}" # music_data:冥:SPA
    [:title, :level, :playtype, :difficulty, :notes].each do |symbol|
      $redis.hset(hash_key, symbol, args[symbol])
    end
  end
end
