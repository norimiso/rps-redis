# -*- coding: utf-8 -*-
class Score
  def initialize(args = {})
    @iidxid     = args[:iidxid]
    @title      = args[:title]
    @playtype   = args[:playtype]   # SP, DP
    @difficulty = args[:difficulty] # N, H, A
  end

  def update(args = {})
    args.each do |arg|
      $redis.hset(score_hash_key, arg.first, arg.second) if arg.length == 2 && valid?
    end
    update_rate(args)
  end

  def update_rate(args)
    music = Music.find(title: @title, playtype: @playtype, difficulty: @difficulty)
    if args[:exscore] && music && music[:notes]
      $redis.hset(score_hash_key, :rate, "%.2f" % (100 * args[:exscore].to_f / (music[:notes].to_f * 2)))
    end
  end

  def valid?
    @iidxid && @title && @playtype && @difficulty
  end

  def score_hash_key
    if @iidxid && @title && @playtype && @difficulty
      "scores:#{@iidxid}:#{@title}:#{@playtype + @difficulty}" # score:1111-1111:冥:SPA
    else
      "dummy"
    end
  end

  def self.where(args = {})
    @score = self.new(args)
    hash = Hash.new
    args.each do |arg|
      hash[arg.first] = arg.second
    end
    [:exscore, :bp, :rate, :clear].each do |symbol|
      hash[symbol] = $redis.hget(@score.score_hash_key, symbol) if @score.valid?
      hash[symbol] ||= case symbol
                       when :bp, :clear then "-"
                       else 0
                       end
    end
    hash
  end
end
