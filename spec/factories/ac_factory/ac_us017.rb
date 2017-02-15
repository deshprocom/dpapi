module AcFactory
  class AcUs017 < AcBase
    def ac_us017_01
      ticket_params = params.permit(:status,
                                    :price,
                                    :name).as_json
      FactoryGirl.create(:race_ticket, ticket_params)
    end

    def ac_us017
      generate_race
    end
  end
end
