# -*- coding: utf-8 -*-
class PowersController < ApplicationController
  def update
    update_power(params[:iidxid])
    render text: "update succeeded"
  end

  def update_power(iidxid)
    hash = Hash.new
    hash[:iidxid] = iidxid
    ["SP", "DP"].each do |playtype|
      [8, 9, 10].each do |level|
        score_sym = (playtype.downcase + level.to_s + "score").to_sym
        title_sym = (playtype.downcase + level.to_s + "title").to_sym
        hash[score_sym], hash[title_sym] = single_score_power(iidxid, playtype, level)
      end
      [11, 12].each do |level|
        score_sym = (playtype.downcase + level.to_s + "score").to_sym
        hash[score_sym] = total_score_power(iidxid, playtype, level)
        clear_sym = (playtype.downcase + level.to_s + "clear").to_sym
        hash[clear_sym] = clear_power(iidxid, playtype, level)
      end
      total_sym = (playtype.downcase + "total").to_sym
      hash[total_sym] = 0
      (8..12).each do |level|
        score_sym = (playtype.downcase + level.to_s + "score").to_sym
        hash[total_sym] += hash[score_sym]
      end
      cleartotal_sym = (playtype.downcase + "total").to_sym
      hash[cleartotal_sym] = 0
      (11..12).each do |level|
        clear_sym = (playtype.downcase + level.to_s + "clear").to_sym
        hash[cleartotal_sym] += hash[clear_sym]
      end
    end
    Power.update(hash)
  end

  def update_all
    @users = User.all
    @users.each do |user|
      update_power(user[:iidxid])
    end
    render text: "update succeeded"
  end

  def clear_power(iidxid, playtype, level)
    # 基礎点:30 * (FC+EXH+H)^2 * 5^((FC+EXH)^2) * 5^(FC^2)
    # 点数:基礎点 ^ (0.75 + 0.5^(0.95+BP/5))
    base = case level
           when 11 then 30
           when 12 then 180
           end
    fc_num = 0
    exh_num = 0
    h_num = 0
    bp_sum = 0
    score_num = 0
    bp_ave = 0
    Music.where(playtype: playtype, level: level.to_s).each do |music|
      score = Score.where(iidxid: iidxid, title: music[:title], playtype: playtype, difficulty: music[:difficulty])
      fc_num += 1 if score[:clear] == "FC"
      exh_num += 1 if score[:clear] == "EH"
      h_num += 1 if score[:clear] == "H"
      if score[:bp] != "-"
        bp_sum += score[:bp]
        score_num += 1
      end
    end

    bp_ave = bp_sum.to_f / score_num if score_num > 0
    k = case level
        when 11 then 0.75 + 0.5**(0.95 + bp_ave / 5)
        when 12 then 0.75 + 0.5**(0.9 + bp_ave / 13)
        end
    base_point = base * (fc_num + exh_num + h_num)**2 * 5**((fc_num + exh_num)**2) * 5**(fc_num**2)
    base_point**k
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
    base = case level
           when 11 then 50
           when 12 then 200
           end
    score_rate = 0
    score_num = 0
    aaa_num = 0
    aa_num = 0
    rate_sum = 0
    Music.where(playtype: playtype, level: level.to_s).each do |music|
      score = Score.where(iidxid: iidxid, title: music[:title], playtype: playtype, difficulty: music[:difficulty])
      if score[:rate].to_f > 0
        score_num += 1
        rate_sum += score[:rate]
        if score[:rate].to_f > 88.8
          aaa_num += 1
        elsif score[:rate].to_f > 77.7
          aa_num += 1
        end
      end
    end

    score_rate = rate_sum / score_num if score_num > 0
    if 1 > score_rate && score_rate > 0
      pika_great = (score_rate - 0.5) / (1 - score_rate)
      score_power = base * (aaa_num.to_f / score_num + 1) * ((aaa_num + aa_num).to_f / score_num) * pika_great / 2;
    else
      score_power = 0
    end
    score_power
  end
end
