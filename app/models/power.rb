class Power
  def self.update(args = {})
    return unless args[:iidxid]
    args.each do |arg|
      next if arg.first == :iidxid
      if arg.second
        $redis.set("powers:#{args[:iidxid]}:#{arg.first}", arg.second)
        $redis.sadd("powers:#{args[:iidxid]}", arg.first)
      end
    end
  end

  def self.find(args = {})
    return unless args[:iidxid]
    hash = Hash.new
    powers = $redis.smembers("powers:#{args[:iidxid]}")
    powers.each do |power|
      hash[power.to_sym] = $redis.get("powers:#{args[:iidxid]}:#{power}")
    end
    hash
  end
end
