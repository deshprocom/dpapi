# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
desh = Affiliate.where(aff_uuid: '94bff89e53611ac7fbb3786a03157486').first
if desh.nil?
  desh = Affiliate.new
  desh.aff_uuid = '94bff89e53611ac7fbb3786a03157486'
  desh.aff_name = '深圳市德尚全彩体育文化有限公司'
  desh.aff_type = 'company'
  desh.status = 0
  desh.save
end

unless AffiliateApp.exists?(app_key: '467109f4b44be6398c17f6c058dfa7ee')
  apps = AffiliateApp.new
  apps.affiliate = desh
  apps.app_id = 'dpapi'
  apps.app_name = '深圳市德尚全彩体育文化有限公司'
  apps.app_key = '467109f4b44be6398c17f6c058dfa7ee'
  apps.app_secret = '18ca083547bb164b94a0f89a7959548b'
  apps.status = 0
  apps.save
end
