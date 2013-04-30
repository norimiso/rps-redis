class User
  def self.all
    users = $redis.smembers("users")
    users.map do |user|
      hash = Hash.new
      [:iidxid, :djname].each do |symbol|
        hash[symbol] = $redis.hget("users:#{user}", symbol)
      end
      hash
    end
  end

  def self.create(args = {})
    return unless args[:iidxid]
    return unless args[:djname]

    $redis.sadd("users", args[:iidxid])
    args.each do |arg|
      $redis.hset("users:#{args[:iidxid]}", arg.first, arg.second)
    end
  end

  def self.find(args = {})
    return unless args[:iidxid]
    return unless $redis.smembers("users").include?(args[:iidxid])
    hash = Hash.new
    [:iidxid, :djname].each do |symbol|
      hash[symbol] = $redis.hget("users:#{args[:iidxid]}", symbol)
    end
    hash
  end
end
