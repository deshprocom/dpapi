require 'rails_helper'

RSpec.describe Services::UniqueNumberGenerator do
  let(:e_ticket_params) do
    {
      ticket_type: 'e_ticket',
      email: 'test@gmail.com',
    }
  end
  let!(:race) { FactoryGirl.create(:race, ticket_status: 'selling') }
  let!(:race_info) { FactoryGirl.create(:ticket_info, race: race) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_extra) { FactoryGirl.create(:user_extra, user: user, status: 'passed') }
  let(:generate_order) do

  end
  context '当ticket_info lock_version不正确时' do
    it '应进行重试机制，并购票成功' do
      ticket_info = TicketInfo.find race.ticket_info.id
      ticket_info.e_ticket_sold_number = 10
      ticket_info.save
      result = Services::Orders::CreateOrderService.call(race, user, e_ticket_params)
      expect(result.code).to eq(0)
    end

    it '应进行重试机制，并返回已电子票已售完' do
      ticket_info = TicketInfo.find race.ticket_info.id
      ticket_info.e_ticket_sold_number = 10
      ticket_info.e_ticket_number = 10
      ticket_info.save
      result = Services::Orders::CreateOrderService.call(race, user, e_ticket_params)
      expect(result.code).to eq(1100040)
    end

    it '达重试次数上限，应返回系统错误' do
      ticket_info = TicketInfo.find race.ticket_info.id
      ticket_info.e_ticket_sold_number = 10
      ticket_info.e_ticket_number = 10
      ticket_info.save
      Services::Orders::CreateOrderService::LOCK_RETRY_TIMES = 0
      result = Services::Orders::CreateOrderService.call(race, user, e_ticket_params)
      expect(result.code).to eq(1100007)
      Services::Orders::CreateOrderService::LOCK_RETRY_TIMES = 2
    end
  end
end