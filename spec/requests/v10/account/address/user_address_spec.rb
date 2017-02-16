require 'rails_helper'

RSpec.describe '/v10/races/:race_id/new_order', :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:http_headers) do
    {
        ACCEPT: 'application/json',
        HTTP_ACCEPT: 'application/json',
        HTTP_X_DP_CLIENT_IP: 'localhost',
        HTTP_X_DP_APP_KEY: '467109f4b44be6398c17f6c058dfa7ee'
    }
  end
  let!(:user) { FactoryGirl.create(:user) }
  let(:shipping_address) { FactoryGirl.create(:shipping_address, user: user) }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end

  context "未登录情况下访问接口" do
    context "获取用户收货地址" do
      it "应当返回code: 805" do
        get v10_account_user_address('nonexistent'),
            headers: http_headers
        expect(response).to have_http_status(805)
      end
    end

    context "增加用户收货地址" do
      it "应当返回code: 805" do
        post v10_account_user_address('nonexistent'),
            headers: http_headers
        expect(response).to have_http_status(805)
      end
    end

    context "修改用户收货地址" do
      it "应当返回code: 805" do
        put v10_account_user_address('nonexistent'),
             headers: http_headers
        expect(response).to have_http_status(805)
      end
    end

    context "删除用户收货地址" do
      it "应当返回code: 805" do
        delete v10_account_user_address('nonexistent'),
             headers: http_headers
        expect(response).to have_http_status(805)
      end
    end
  end

  context "非本人操作接口" do
    context "获取用户收货地址" do
      it "应当返回code: 806" do
        get v10_account_user_address(12345),
            headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token})
        expect(response).to have_http_status(806)
      end
    end

    context "增加用户收货地址" do
      it "应当返回code: 806" do
        post v10_account_user_address(12345),
            headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token})
        expect(response).to have_http_status(806)
      end
    end

    context "修改用户收货地址" do
      it "应当返回code: 806" do
        put v10_account_user_address(12345),
            headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token})
        expect(response).to have_http_status(806)
      end
    end

    context "删除用户收货地址" do
      it "应当返回code: 806" do
        delete v10_account_user_address(12345),
            headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token})
        expect(response).to have_http_status(806)
      end
    end
  end

  context "用户已登录，并且是本人操作" do
    context "获取用户收货地址" do
      context "用户还没有收货地址" do
        it "应当返回code: 1100041" do
          get v10_account_user_address(user.user_uuid),
              headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token})
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          expect(json['code']).to eq(1100041)
        end
      end

      context "用户有收货地址" do
        it "应当返回code: 0" do
          get v10_account_user_address(user.user_uuid),
              headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token})
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          expect(json['code']).to eq(0)
          item = json['data']['item']
          expect(item[0]['consignee']).to be_truthy
          expect(item[0]['mobile']).to be_truthy
          expect(item[0]['address_detail']).to be_truthy
          expect(item[0]['post_code']).to be_truthy
        end
      end
    end

    context "新增用户收货地址" do
      context "缺少参数" do
        it "应当返回code: 1100001" do
          post v10_account_user_address(user.user_uuid),
               params: { consignee: 'test', mobile: '13677882233', address: 'test' },
              headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token})
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          expect(json['code']).to eq(1100001)
        end

        it "应当返回code: 1100001" do
          post v10_account_user_address(user.user_uuid),
               params: { consignee: 'test', mobile: '13677882233', address_detail: 'test' },
               headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token})
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          expect(json['code']).to eq(1100001)
        end

        it "应当返回code: 1100001" do
          post v10_account_user_address(user.user_uuid),
               params: { consignee: 'test', address: 'test', address_detail: 'test' },
               headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token})
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          expect(json['code']).to eq(1100001)
        end

        it "应当返回code: 1100001" do
          post v10_account_user_address(user.user_uuid),
               params: { mobile: '13677882233', address: 'test', address_detail: 'test' },
               headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token})
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          expect(json['code']).to eq(1100001)
        end
      end

      context "手机号格式不正确" do
        it "应当返回code: 1100012" do
          post v10_account_user_address(user.user_uuid),
               params: { consignee: 'test', mobile: '1376655', address: 'test', address_detail: 'test' },
               headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token})
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          expect(json['code']).to eq(1100012)
        end
      end

      context "保存成功" do
        it "应当返回code: 0" do
          post v10_account_user_address(user.user_uuid),
               params: { consignee: 'test', mobile: '13713665566', address: 'test', address_detail: 'test' },
               headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token})
          expect(response).to have_http_status(200)
          json = JSON.parse(response.body)
          expect(json['code']).to eq(0)
        end
      end
    end
  end
end