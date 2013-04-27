class MusicsController < ApplicationController
  include HTTParty

  def index
    @musics = Hash.new
    ["SP", "DP"].each do |playtype|
      @musics[playtype] = Hash.new
      (1..12).each do |level|
        @musics[playtype][level] = Music.where(playtype: playtype, level: level)
      end
    end
  end

  def update
    update_music_data
    render text: "update succeeded"
  end

  def update_music_data
    music_list = textage_music_list
    music_list.each do |music|
      [:spn, :sph, :spa, :dpn, :dph, :dpa].each do |symbol|
        playtype = case symbol
                   when :spn, :sph, :spa then "SP"
                   when :dpn, :dph, :dpa then "DP"
                   end
        difficulty = case symbol
                     when :spn, :dpn then "N"
                     when :sph, :dph then "H"
                     when :spa, :dpa then "A"
                     end
        level = case music[symbol]
                when "A" then "10"
                when "B" then "11"
                when "C" then "12"
                else music[symbol]
                end
        Music.add(level: level, title: music[:title], difficulty: difficulty, playtype: playtype, notes: "2000")
      end
    end
  end

  # Thanks for TexTage(http://textage.cc/)
  def textage_music_list
    music_list = Array.new
    script = get("http://textage.cc/score/actbl.js")
    script.each_line do |line|
      if line =~ /'(.+)'\s+:\[(.+)\],/
        numbers = $2.split(',')
        music_list += [{
            title: $1,
            version: numbers[6],
            spn: numbers[5],
            sph: numbers[7],
            spa: numbers[9],
            dpn: numbers[15],
            dph: numbers[17],
            dpa: numbers[19]
        }]
      end
    end
    music_list
  end

  def get(args)
    self.class.get(args)
  end
end
