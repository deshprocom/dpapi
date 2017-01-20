def create(name, prize, location, begin_date, change_id, end_date)
  race = Race.new
  race.name = name
  race.seq_id = begin_date + change_id
  race.prize = prize
  race.location = location
  race.begin_date = begin_date
  race.end_date = end_date
  race.save
end

create('澳洲百万赛', 960, '墨尔本', '2017-01-18', '001', '2017-01-22')
create('IPT(国际扑克巡回赛)', 600, '上海嘉定喜来登酒店', '2017-01-18', '001', '2017-01-23')
create('扑克之星冠军赛-澳门站', 9644, '墨尔本', '2017-01-19', '000', '2017-01-25')
create('TPT腾讯扑克锦标赛', 1080, '深圳', '2017-12-01', '001', '2017-12-06')
create('WPT三亚站', 888, '海南三亚', '2017-10-04', '001', '2017-10-22')
create('WPT Team Dragon', 666, '', '2017-01-18', '001', '2017-01-22')
create('2017皇城五坛系列赛', 118, '北京', '2017-02-22', '000', '2017-02-27')
