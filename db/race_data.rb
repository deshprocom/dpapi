race = Race.new
race.name = '传奇扑克超高额豪客赛'
race.seq_id = 2.days.from_now.strftime('%Y%m%d') + '000'
race.prize = 40000
race.location = '马尼拉'
race.begin_date = 2.days.from_now.strftime('%Y-%m-%d')
race.end_date = 4.days.from_now.strftime('%Y-%m-%d')
race.save
