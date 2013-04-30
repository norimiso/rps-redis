# -*- coding: utf-8 -*-
class PowersController < ApplicationController
  def update
    hash = Hash.new
    hash[:iidxid] = params[:iidxid]
    ["SP", "DP"].each do |playtype|
      [8, 9, 10].each do |level|
        score_sym = (playtype.downcase + level.to_s + "score").to_sym
        title_sym = (playtype.downcase + level.to_s + "title").to_sym
        hash[score_sym], hash[title_sym] = single_score_power(iidxid, playtype, level)
      end

      [11, 12].each do |level|
        ;
      end
    end

    Power.update(hash)
    render text: "update succeeded"
  end

  def single_score_power(iidxid, playtype, level)
    title = "-"
    max_rate = 0
    Music.where(playtype: playtype, level: level.to_s).each do |music|
      score = Score.where(iidxid: iidxid, title: music[:title], playtype: playtype, difficulty: music[:difficulty])
      if max_rate < score[:rate]
        title = music[:title]
        max_rate = score[:rate]
      end
    end
    base = case level
           when 8 then 280
           when 9 then 330
           when 10 then 390
           end

    mas_rate = 99.9 if max_rate == 100
    score_power = base * (0.6 ** (100 - max_rate))
    [score_power, title]
  end

  def total_score_power(iidxid, playtype, level)
    score_rate = 0
    score_num = 0
    rate_sum = 0
    Music.where(playtype: playtype, level: level.to_s).each do |music|
      score = Score.where(iidxid: iidxid, title: music[:title], playtype: playtype, difficulty: music[:difficulty])
      # Do some calc
      if max_rate < score[:rate]
        title = music[:title]
        max_rate = score[:rate]
      end
    end

    score_rate = rate_sum / score_num if score_num > 0
    if 1 > score_rate && score_rate > 0
      pika_great = (score_rate - 0.5) / (1 - score_rate)
      score_power = base * (num_aaa.to_f / num_total + 1) * ((num_aaa + num_aa).to_f / num_total) * pika_great / 2;
    else
      score_power = 0
    end
    score_power
  end
end
