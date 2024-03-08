# frozen_string_literal: true

# Trade object
class QuidaxTrade < QuidaxBaseObject
  def for_user(user_id:)
    QuidaxTrade.for_user(q_object: @quidax, user_id: user_id)
  end

  def for_market(market:)
    QuidaxTrade.for_market(q_object: @quidax, market: market)
  end

  def self.for_user(q_object:, user_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::TRADES_PATH}"

    get_request(q_object, path)
  end

  def self.for_market(q_object:, market:)
    path = "#{API::TRADES_PATH}/#{market}"
    get_request(q_object, path)
  end
end
