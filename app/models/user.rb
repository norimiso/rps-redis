class User
  def self.create(args = {})
    return unless args[:iidxid]
    return unless args[:djname]

    $redis.sadd("user", args[:iidxid])
    $redis.set("user:#{args[:iidxid]}", args[:djname])
  end
end
