class CreateAndSyncVideoTables < ActiveRecord::Migration[5.0]

  def up
    # 创建两个临时表
    create_temp_video_type_en
    create_temp_video_en

    # 同步所有数据到临时表
    sync_data

    # 删除英文表
    drop_table :video_ens
    drop_table :video_type_ens

    # 重命名临时表
    rename_table :temp_video_ens, :video_ens
    rename_table :temp_video_type_ens, :video_type_ens
  end

  def down
    # 回退临时表
    rename_table :video_ens, :temp_video_ens
    rename_table :video_type_ens, :temp_video_type_ens

    # 新建原有英文表
    create_video_ens
    create_video_type_ens

    # 回退数据
    rollback_data

    drop_table :temp_video_ens
    drop_table :temp_video_type_ens
  end

  def create_temp_video_en
    create_table :temp_video_ens do |t|
      t.integer :video_type_id, comment: '外键对应video_type_en_id'
      t.string :name, comment: '视频名称'
      t.string :video_link, comment: '视频链接'
      t.string :cover_link, comment: '封面链接'
      t.boolean :top, default: false, comment: '是否置顶'
      t.boolean :published, default: false, comment: '是否发布'
      t.text :description, comment: '视频描述'
      t.timestamps
      t.string :video_duration, comment: '视频时长'
    end
  end

  def create_temp_video_type_en
    create_table :temp_video_type_ens do |t|
      t.string :name
      t.integer :level, default: 0, comment: '排序'
      t.boolean :published, default: false, comment: '是否发布'
      t.timestamps
    end
  end

  def sync_data
    # 将数据同步到临时表
    execute <<-SQL
      insert into temp_video_ens select * from videos;
    SQL

    execute <<-SQL
      insert into temp_video_type_ens select * from video_types;
    SQL

    # 将原有英文表里面的数据同步到临时表
    execute <<-SQL
      update temp_video_ens t1, video_ens t2 
      set 
      t1.name = t2.name, t1.description = t2.description, t1.created_at = t2.created_at, t1.updated_at = t2.updated_at
      where t1.id = t2.video_id;
    SQL

    # 将原有英文表里面的数据同步到临时表
    execute <<-SQL
      update temp_video_type_ens t1, video_type_ens t2 
      set 
      t1.name = t2.name, t1.created_at = t2.created_at, t1.updated_at = t2.updated_at
      where t1.id = t2.video_type_id;
    SQL
  end

  def create_video_ens
    create_table :video_ens do |t|
      t.references :video
      t.string :name
      t.text :description, comment: '视频英文描述'
      t.timestamps
    end
  end

  def create_video_type_ens
    create_table :video_type_ens do |t|
      t.references :video_type
      t.string :name
      t.timestamps
    end
  end

  def rollback_data
    # 将原有英文表里面的数据同步到临时表
    execute <<-SQL
      insert into video_ens(video_id, name, description, created_at, updated_at) 
      select id, name, description, created_at, updated_at from temp_video_ens;
    SQL

    # 将原有英文表里面的数据同步到临时表
    execute <<-SQL
      insert into video_type_ens(name, created_at, updated_at) 
      select name, created_at, updated_at from temp_video_type_ens;
    SQL
  end
end


























