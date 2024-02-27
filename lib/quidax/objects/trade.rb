# frozen_string_literal: true

# Trade object
class QuidaxTrade < QuidaxBaseObject
  def forUser(user_id:)
    QuidaxTrade.forUser(q_object: @quidax, user_id: user_id)
  end

  def forMarket(market_pair:)
    QuidaxTrade.forMarket(q_object: @quidax, market_pair: market_pair)
  end

  def self.forUser(q_object:, user_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::TRADES_PATH}"

    get_request(q_object, path)
  end

  def self.forMarket(q_object:, market_pair:)
    path = "#{API::TRADES_PATH}/#{market_pair}"
    get_request(q_object, path)
  end
end
