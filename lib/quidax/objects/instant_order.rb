# frozen_string_literal: true

require_relative "../validators/instant_order_validator"

# Instant Order Object
class QuidaxInstantOrder < QuidaxBaseObject
  def get_all(user_id:, market: nil, state: nil, order_by: nil)
    QuidaxInstantOrder.get_all(q_object: @quidax, user_id: user_id, market: market, state: state, order_by: order_by)
  end

  def by_sub_users(side:, start_date:, end_date:, market: nil, state: nil)
    QuidaxInstantOrder.by_sub_users(q_object: @quidax, side: side, start_date: start_date, end_date: end_date, market: market,
                                    state: state)
  end

  def get_detail(user_id:, instant_order_id:)
    QuidaxInstantOrder.get_detail(q_object: @quidax, user_id: user_id, instant_order_id: instant_order_id)
  end

  def buy_crypto_from_fiat(user_id:, body:)
    QuidaxInstantOrder.buy_crypto_from_fiat(q_object: @quidax, user_id: user_id, body: body)
  end

  def sell_crypto_to_fiat(user_id:, body:)
    QuidaxInstantOrder.sell_crypto_to_fiat(q_object: @quidax, user_id: user_id, body: body)
  end

  def confirm(user_id:, instant_order_id:)
    QuidaxInstantOrder.confirm(q_object: @quidax, user_id: user_id, instant_order_id: instant_order_id)
  end

  def requote(user_id:, instant_order_id:)
    QuidaxInstantOrder.requote(q_object: @quidax, user_id: user_id, instant_order_id: instant_order_id)
  end

  def self.get_all(q_object:, user_id:, market: nil, state: nil, order_by: nil)
    market ||= "btcngn"
    state ||= "done"
    order_by ||= "asc"

    allowed_order_by = %w[asc desc]
    Utils.validate_value_in_array(array: allowed_order_by, value: order_by, field: "order_by")

    allowed_states = %w[done wait cancel confirm]
    Utils.validate_value_in_array(array: allowed_states, value: state, field: "state")

    path = "#{API::USER_PATH}/#{user_id}#{API::INSTANT_ORDER_PATH}"
    params = {
      market: market,
      state: state,
      order_by: order_by
    }

    get_request(q_object, path, params)
  end

  def self.by_sub_users(q_object:, side:, start_date:, end_date:, market: nil, state: nil)
    state ||= "done"
    market ||= "btcngn"

    allowed_sides = %w[buy sell]
    Utils.validate_value_in_array(array: allowed_sides, value: side, field: "side")

    allowed_states = %w[pend wait confirm done partially_done failed cancel]
    Utils.validate_value_in_array(array: allowed_states, value: state, field: "state")
    path = "#{API::USER_PATH}#{API::INSTANT_ORDER_PATH}/all"

    params = {
      side: side,
      state: state,
      market: market,
      start_date: start_date,
      end_date: end_date
    }

    get_request(q_object, path, params)
  end

  def self.get_detail(q_object:, user_id:, instant_order_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::INSTANT_ORDER_PATH}/#{instant_order_id}"

    get_request(q_object, path)
  end

  def self.buy_crypto_from_fiat(q_object:, user_id:, body:)
    body.transform_keys!(&:to_s)

    InstantOrderValidator.validate_buy_from_crypto_body(body)
    type = "buy"
    unit = body["bid"]
    body["unit"] = unit
    body["type"] = type

    path = "#{API::USER_PATH}/#{user_id}#{API::INSTANT_ORDER_PATH}"
    post_request(q_object, path, body)
  end

  def self.sell_crypto_to_fiat(q_object:, user_id:, body:)
    body.transform_keys!(&:to_s)
    InstantOrderValidator.validate_sell_crypto_to_fiat(body)
    unit = body["bid"]
    body["unit"] = unit
    body["type"] = "sell"

    path = "#{API::USER_PATH}/#{user_id}#{API::INSTANT_ORDER_PATH}"
    post_request(q_object, path, body)
  end

  def self.confirm(q_object:, user_id:, instant_order_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::INSTANT_ORDER_PATH}/#{instant_order_id}/confirm"

    post_request(q_object, path)
  end

  def self.requote(q_object:, user_id:, instant_order_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::INSTANT_ORDER_PATH}/#{instant_order_id}/requote"

    post_request(q_object, path)
  end
end
