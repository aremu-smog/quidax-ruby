# frozen_string_literal: true

# Beneficiary object
class QuidaxBeneficiary < QuidaxBaseObject
  def get_all(user_id:, query:)
    QuidaxBeneficiary.get_all(q_object: @quidax, user_id: user_id, query: query)
  end

  def create(user_id:, body:)
    QuidaxBeneficiary.create(q_object: @quidax, user_id: user_id, body: body)
  end

  def get_account(user_id:, beneficiary_id:)
    QuidaxBeneficiary.get_account(q_object: @quidax, user_id: user_id, beneficiary_id: beneficiary_id)
  end

  def edit_account(user_id:, beneficiary_id:, body:)
    QuidaxBeneficiary.edit_account(q_object: @quidax, user_id: user_id, beneficiary_id: beneficiary_id, body: body)
  end

  def self.get_all(q_object:, user_id:, query:)
    query.stringify_keys!
    allowed_currencies = %w[btc ltc xrp dash trx doge]
    Utils.check_missing_keys(required_keys: %w[currency], keys: query.keys, field: "query")

    currency = query["currency"]
    Utils.validate_value_in_array(array: allowed_currencies, value: currency, field: "currency")

    path = "#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}"

    get_request(q_object, path, query)
  end

  def self.create(q_object:, user_id:, body:)
    body.stringify_keys!
    expected_query_keys = %w[currency uid extra]
    Utils.check_missing_keys(required_keys: expected_query_keys, keys: body.keys, field: "body")

    path = "#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}"

    post_request(q_object, path, body)
  end

  def self.get_account(q_object:, user_id:, beneficiary_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}/#{beneficiary_id}"

    get_request(q_object, path)
  end

  def self.edit_account(q_object:, user_id:, beneficiary_id:, body:)
    body.stringify_keys!
    path = "#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}/#{beneficiary_id}"

    Utils.check_missing_keys(required_keys: %w[uid], keys: body.keys, field: "body")

    put_request(q_object, path, body)
  end
end
