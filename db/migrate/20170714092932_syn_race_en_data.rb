class SynRaceEnData < ActiveRecord::Migration[5.0]
  def change
    remove_column(:race_descs, :schedule)
    create_table 'race_desc_ens', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'race_id'
      t.text     'description', limit: 65535
      t.datetime 'created_at',                null: false
      t.datetime 'updated_at',                null: false
      t.index ['race_id'], name: 'index_race_descs_on_race_id', using: :btree
    end

    json_races = Race.all.map do |race|
      race_hash = race.attributes

      race_en = RaceEn.find_by(race_id: race.id)
      desc_en = RaceDescEn.new race.race_desc.as_json
      if race_en
        desc_en.description = race_en.description unless race_en.description.blank?
        race_hash['logo'] = race[:logo] unless race_en.logo.blank?
        race_hash['name'] = race.name unless race_en.name.blank?
        race_hash['prize'] = race.prize unless race_en.prize.blank?
        race_hash['location'] = race.location unless race_en.location.blank?
        race_hash['ticket_price'] = race.ticket_price unless race_en.ticket_price.blank?
        race_hash['blind'] = race.blind unless race_en.blind.blank?
      end
      desc_en.save
      race_hash
    end

    drop_table :race_ens
    create_table 'race_ens', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   'name',            limit: 256,                              comment: '赛事的名称'
      t.bigint   'seq_id',                      default: 0,     null: false, comment: '为每一个赛事增加的id'
      t.string   'logo',            limit: 256,                              comment: '赛事的logo'
      t.string   'prize',                       default: '',    null: false, comment: '赛事的奖池'
      t.string   'location',        limit: 256,                              comment: '赛事比赛地点'
      t.date     'begin_date',                                               comment: '赛事开始日期'
      t.date     'end_date',                                                 comment: '赛事结束的日期'
      t.integer  'status',                      default: 0,     null: false, comment: '赛事的状态 0-未开始  1-进行中  2-已结束  3-已关闭'
      t.datetime 'created_at',                                  null: false
      t.datetime 'updated_at',                                  null: false
      t.string   'ticket_price',                default: '',                 comment: '票的价格'
      t.boolean  'published',                   default: false,              comment: '该赛事是否已发布'
      t.boolean  'ticket_sellable',             default: true,               comment: '是否可以售票'
      t.boolean  'describable',                 default: true,               comment: '是否有详情内容'
      t.integer  'parent_id',                   default: 0,                  comment: '主赛的parent_id默认为0， 边赛的parent_id为主赛的id'
      t.boolean  'roy',                         default: false,              comment: '是否有roy'
      t.string   'blind',                       default: '',                 comment: '赛事的盲注'
      t.integer  'participants',                                             comment: '赛事的参与人数'
      t.integer  'race_host_id'
      t.index ['begin_date'], name: 'index_races_on_begin_date', using: :btree
      t.index ['parent_id'], name: 'index_races_on_parent_id', using: :btree
      t.index ['race_host_id'], name: 'index_races_on_race_host_id', using: :btree
      t.index ['seq_id'], name: 'index_races_on_seq_id', unique: true, using: :btree
    end
    RaceEn.connection.schema_cache.clear!
    RaceEn.reset_column_information
    json_races.each do |race|
      RaceEn.create(race)
    end

    drop_table :ticket_ens
    create_table 'ticket_ens', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'race_id'
      t.string   'title',          limit: 256,                                   comment: '票名称'
      t.string   'logo',           limit: 256,                                   comment: '票缩略图'
      t.integer  'price',                                                        comment: '折后价格'
      t.integer  'original_price',                                               comment: '原始价格'
      t.datetime 'created_at',                                      null: false
      t.datetime 'updated_at',                                      null: false
      t.string   'ticket_class',                 default: 'race',                comment: '类型:single_ticket -> 仅赛票, package_ticket -> 套票'
      t.text     'description',    limit: 65535,                                 comment: '赛票描述'
      t.string   'status',         limit: 30,    default: 'unsold',              comment: '售票的状态 unsold-未售票, selling-售票中, end-售票结束, sold_out-票已售完'
      t.index ['race_id'], name: 'index_tickets_on_race_id', using: :btree
    end
  end
end
