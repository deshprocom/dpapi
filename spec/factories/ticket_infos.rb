FactoryGirl.define do
  factory :ticket_info do
    association       :ticket
    total_number      100
    e_ticket_number   50
    entity_ticket_number   0
    e_ticket_sold_number   0
    entity_ticket_sold_number 0
  end
end
