# validate instant orders
module InstantOrderValidator
  def self.validate_buy_from_crypto_body(body)
    required_body_keys = %w[bid ask volume]

    Utils.check_missing_keys(required_keys: required_body_keys, keys: body.keys, field: "body")
    validate_bid_currency(body["bid"])
    validate_ask_currency(body["ask"])
  end

  def self.validate_sell_crypto_to_fiat(body)
    required_body_keys = %w[bid ask total]

    Utils.check_missing_keys(required_keys: required_body_keys, keys: body.keys, field: "body")
    validate_bid_currency(body["bid"])
    validate_ask_currency(body["ask"])
  end

  class << self
    private

    def validate_bid_currency(bid_currency)
      allowed_bid_currencies = %w[ngn usdt]
      Utils.validate_value_in_array(array: allowed_bid_currencies, value: bid_currency, field: "bid")
    end

    def validate_ask_currency(ask_currency)
      allowed_ask_currencies = %w[btc ltc eth xrp usdt dash usdc busd bnb]
      Utils.validate_value_in_array(array: allowed_ask_currencies, value: ask_currency, field: "ask")
    end
  end
end
