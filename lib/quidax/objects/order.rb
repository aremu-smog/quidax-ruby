# frozen_string_literal: true

# Order object
class QuidaxOrder < QuidaxBaseObject
  def get_all(user_id:, query:)
    QuidaxOrder.get_all(q_object: @quidax, user_id: user_id, query: query)
  end

  def create(user_id:, body:)
    QuidaxOrder.create(q_object: @quidax, user_id: user_id, body: body)
  end

  def cancel(user_id:, order_id:)
    QuidaxOrder.cancel(q_object: @quidax, user_id: user_id, order_id: order_id)
  end

  def get_details(user_id:, order_id:)
    QuidaxOrder.get_details(q_object: @quidax, user_id: user_id, order_id: order_id)
  end

  def self.get_all(q_object:, user_id:, query:)
    query.stringify_keys!
    Utils.check_missing_keys(required_keys: %w[market], keys: query.keys, field: "query")
    query["order_by"] = "asc" unless query.include?("order_by")
    query["state"] = "done" unless query.include?("state")
    Utils.validate_value_in_array(array: %w[asc desc], value: query["order_by"], field: 'query["order_by"]')
    Utils.validate_value_in_array(array: %w[done wait cancel], value: query["state"], field: 'query["state"]')

    path = "#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}"

    get_request(q_object, path, query)
  end

  def self.create(q_object:, user_id:, body:)
    body.stringify_keys!

    expected_data_keys = %w[market side ord_type price volume]
    Utils.check_missing_keys(required_keys: expected_data_keys, keys: body.keys, field: "body")

    Utils.validate_value_in_array(array: %w[buy sell], value: body["side"], field: 'body["side"]')
    body["ord_type"] = "limit" unless body.include?("ord_type")
    Utils.validate_value_in_array(array: %w[limit market], value: body["ord_type"], field: 'body["ord_type"]')

    path = "#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}"

    post_request(q_object, path, body)
  end

  def self.cancel(q_object:, user_id:, order_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}/#{order_id}/cancel"

    post_request(q_object, path)
  end

  def self.get_details(q_object:, user_id:, order_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}/#{order_id}"

    get_request(q_object, path)
  end
end
