class User
  def self.create(iidxid)
    $redis.sadd("user", iidxid)
  end
end
