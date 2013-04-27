class Score
  def initialize(args = {})
    raise ArgumentError, "invalid argument" unless args[:iidxid] && args[:music] && args[:playtype] && args[:difficulty]
    @iidxid     = args[:iidxid]
    @music      = args[:music]
    @playtype   = args[:playtype]   # SP, DP
    @difficulty = args[:difficulty] # N, H, A
  end

  def update(args = {})
    args.each do |arg|
      $redis.hset(score_hash_key, arg.first, arg.second) if arg.length == 2
    end
  end

  def score_hash_key
    "score:#{@iidxid}:#{@music}:#{@playtype}:#{@difficulty}"
  end
end
