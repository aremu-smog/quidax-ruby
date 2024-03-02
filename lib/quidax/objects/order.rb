# frozen_string_literal: true

# Order object
class QuidaxOrder < QuidaxBaseObject
  def getAll(user_id:, market:, state:, order_by:)
    QuidaxOrder.getAll(q_object: @quidax, user_id: user_id, market: market, order_by: order_by, state: state)
  end

  def create(user_id:, data:)
    QuidaxOrder.create(q_object: @quidax, user_id: user_id, data: data)
  end

  def cancel(user_id:, order_id:)
    QuidaxOrder.cancel(q_object: @quidax, user_id: user_id, order_id: order_id)
  end

  def getDetails(user_id:, order_id:)
    QuidaxOrder.getDetails(q_object: @quidax, user_id: user_id, order_id: order_id)
  end

  def self.create(q_object:, user_id:, data:) # rubocop:disable Metrics/AbcSize
    path = "#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}"

    expected_data_keys = %w[market side ord_type price volume]
    data.transform_keys!(&:to_s)
    data_keys = data.keys
    diff_in_data_keys = expected_data_keys - data_keys.map(&:to_s)
    missing_keys = diff_in_data_keys.join(", ")
    has_missing_keys = diff_in_data_keys.empty?
    raise ArgumentError, "#{missing_keys} are missing in :data" unless has_missing_keys

    allowed_sides = %w[buy sell]
    unless allowed_sides.include?(data["side"])
      raise ArgumentError,
            "data['side'] must be one of #{allowed_sides.join(", ")}"
    end

    allowed_ord_type = %w[limit market]
    unless allowed_ord_type.include?(data["ord_type"])
      raise ArgumentError,
            "data['ord_type'] must be one of #{allowed_ord_type.join(", ")}"
    end

    post_request(q_object, path, data)
  end

  def self.cancel(q_object:, user_id:, order_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}/#{order_id}/cancel"

    post_request(q_object, path)
  end

  def self.getAll(q_object:, user_id:, market:, state:, order_by:)
    allowed_order_values = %w[asc desc]
    order_by ||= "asc"
    unless allowed_order_values.include?(order_by.downcase)
      raise ArgumentError,
            ":order_by must be one of: #{allowed_order_values.join(", ")}"
    end

    path = "#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}"

    params = {
      market: market,
      state: state,
      order_by: order_by
    }

    get_request(q_object, path, params)
  end

  def self.getDetails(q_object:, user_id:, order_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}/#{order_id}"

    get_request(q_object, path)
  end
end
