class MusicsController < ApplicationController
  include HTTParty

  def index
  end

  def update
    update_music_data
    render text: "update succeeded"
  end

  def update_music_data
    hash = textage_music_list
  end

  # Thanks for TexTage(http://textage.cc/)
  def textage_music_list
    hash = Array.new
    script = get("http://textage.cc/score/actbl.js")
    script.each_line do |line|
      if line =~ /'(.+)'\s+:\[(.+)\],/
        numbers = $2.split(',')
        hash += [{
            name: $1,
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
#    raise hash.to_yaml
  end

  def get(args)
    self.class.get(args)
  end
end
