class User
  def self.all
    users = $redis.smembers("user")
    users.map do |user|
      hash = Hash.new
      [:iidxid, :djname].each do |symbol|
        hash[symbol] = $redis.hget("user:#{user}", symbol)
      end
    end
  end

  def self.create(args = {})
    return unless args[:iidxid]
    return unless args[:djname]

    $redis.sadd("user", args[:iidxid])
    args.each do |arg|
      $redis.hset("user:#{args[:iidxid]}", arg.first, arg.second)
    end
  end
end
