module AcFactory
  class AcUs017 < AcBase
    def ac_us017_001
      ticket_params = params.permit(:status,
                                    :price,
                                    :name).as_json
      FactoryGirl.create(:race_ticket, ticket_params)
    end

    def ac_us017_04
      race = generate_race
      user = User.by_email(params[:email])
      FactoryGirl.create(:race_order, race_id: race.id, user_id: user.id)
    end

    def ac_us017
      generate_race
    end
  end
end
