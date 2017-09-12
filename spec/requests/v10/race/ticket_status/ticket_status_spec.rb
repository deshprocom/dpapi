# require 'rails_helper'

# RSpec.describe '/v10/races/:race_id/ticket_status', :type => :request do
#   let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
#   let(:http_headers) do
#     {
#         ACCEPT: 'application/json',
#         HTTP_ACCEPT: 'application/json',
#         HTTP_X_DP_CLIENT_IP: 'localhost',
#         HTTP_X_DP_APP_KEY: '467109f4b44be6398c17f6c058dfa7ee'
#     }
#   end
#   let(:race1) { FactoryGirl.create(:race) }
#   let(:race2) { FactoryGirl.create(:race) }
#   let(:race3) { FactoryGirl.create(:race) }
#   let(:race4) { FactoryGirl.create(:race) }
#
#   context '赛事不存在' do
#     it '应当返回code 1100006' do
#       get v10_race_ticket_status_url('nonexistent'),
#           headers: http_headers
#       expect(response).to have_http_status(200)
#       json = JSON.parse(response.body)
#       expect(json['code']).to eq(1100006)
#     end
#   end
#
#   context '赛事存在' do
#     context '票已售完' do
#       it '应当返回code 1100031' do
#         get v10_race_ticket_status_url(race1.id),
#             headers: http_headers
#         expect(response).to have_http_status(200)
#         json = JSON.parse(response.body)
#         expect(json['code']).to eq(1100031)
#       end
#     end
#
#     context '售票还没开始' do
#       it '应当返回code 1100032' do
#         get v10_race_ticket_status_url(race2.id),
#             headers: http_headers
#         expect(response).to have_http_status(200)
#         json = JSON.parse(response.body)
#         expect(json['code']).to eq(1100032)
#       end
#     end
#
#     context '售票结束' do
#       it '应当返回code 1100038' do
#         get v10_race_ticket_status_url(race3.id),
#             headers: http_headers
#         expect(response).to have_http_status(200)
#         json = JSON.parse(response.body)
#         expect(json['code']).to eq(1100038)
#       end
#     end
#
#     context '正在售票' do
#       it '应当返回code 0' do
#         get v10_race_ticket_status_url(race4.id),
#             headers: http_headers
#         expect(response).to have_http_status(200)
#         json = JSON.parse(response.body)
#         expect(json['code']).to eq(0)
#       end
#     end
#
#   end
# end