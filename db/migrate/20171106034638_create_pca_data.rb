class CreatePcaData < ActiveRecord::Migration[5.0]
  require './db/provinces'
  require './db/cities'
  require './db/areas'

  def up
    create_province
    create_city
    create_area
  end

  def down
    destroy_province
    destroy_city
    destroy_area
  end

  private
  def create_province
    return if Province.count > 0
    PROVINCE_LIST.collect do |item|
      Province.create(id: item[:id], name: item[:name], province_id: item[:province_id])
    end
  end

  def destroy_province
    Province.destroy_all
  end

  def create_city
    return if City.count > 0
    CITY_LIST.collect do |item|
      City.create(id: item[:id], city_id: item[:city_id], name: item[:name], province_id: item[:province_id])
    end
  end

  def destroy_city
    City.destroy_all
  end

  def create_area
    return if Area.count > 0
    AREA_LIST.collect do |item|
      Area.create(id: item[:id], name: item[:name], area_id: item[:area_id], city_id: item[:city_id])
    end
  end

  def destroy_area
    Area.destroy_all
  end
end
