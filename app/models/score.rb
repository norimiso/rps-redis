class Score
  def self.update(args = {})
    return unless args[:iidxid]
    return unless args[:music]
    return unless args[:difficulty]
    return unless args[:value]

    key = "score:#{args[:iidxid]}:#{args[:music]}:#{args[:difficulty]}"
    $redis.set(key, args[:value]);
  end
end
