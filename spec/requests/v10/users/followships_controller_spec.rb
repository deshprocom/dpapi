require 'rails_helper'
require 'request_helper'

RSpec.describe "/v10/users/:user_id/followships", :type => :request do
  include RequestHelper

  let(:user2) { FactoryGirl.create(:user, { user_uuid: 'test123', user_name: 'Geek', mobile: '13655667766', email: 'test2@deshpro.com' }) }
  let(:followship) { FactoryGirl.create(:followship, {follower_id: user.id, following_id: user2.id}) }
  
  it '返回关注列表与粉丝列表' do
    get v10_user_followships_url(user.user_uuid), **header_with_token
    expect(response).to have_http_status(200)
    json = JSON.parse(response.body)
    expect(json['code']).to eq(0)
    expect(json['data']['followers'].size).to eq(0)
  end

  it '关注用户' do
    post v10_user_followships_url(user.user_uuid), params: {target_id: user2.id}, **header_with_token
    expect(response).to have_http_status(200)
    json = JSON.parse(response.body)
    expect(json['code']).to eq(0)
  end

  it '取消关注' do
    delete v10_user_followships_url(user.user_uuid), params: {target_id: followship.following_id}, **header_with_token
    expect(response).to have_http_status(200)
    json = JSON.parse(response.body)
    expect(json['code']).to eq(0)
  end

end
