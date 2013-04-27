class Music
  def self.add(args = {})
    return unless args[:level] && args[:title] && args[:difficulty] && args[:notes]
    $redis.sadd(level_set_key(args[:level].first), )
  end

  def add_to_level_set(level, title)
    $redis.sadd(level_set_key(level), "#{title}:#{difficulty}")
  end

  def level_set_key(level)
    "music:level:#{level}"
  end
end
