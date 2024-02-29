# frozen_string_literal: true

# Beneficiary object
class QuidaxBeneficiary < QuidaxBaseObject
  def getAll(user_id:, currency:)
    QuidaxBeneficiary.getAll(q_object: @quidax, user_id: user_id, currency: currency)
  end

  def getAccount(user_id:, beneficiary_id:)
    QuidaxBeneficiary.getAccount(q_object: @quidax, user_id: user_id, beneficiary_id: beneficiary_id)
  end

  def create(user_id:, data:)
    QuidaxBeneficiary.create(q_object: @quidax, user_id: user_id, data: data)
  end

  def editAccount(user_id:, beneficiary_id:, data:)
    QuidaxBeneficiary.editAccount(q_object: @quidax, user_id: user_id, beneficiary_id: beneficiary_id, data: data)
  end

  def self.getAll(q_object:, user_id:, currency:)
    allowed_currencies = %w[btc ltc xrp dash trx doge]
    raise ArgumentError, "#{currency} is not allowed" unless allowed_currencies.include?(currency)

    path = "#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}"
    params = {
      currency: currency
    }
    get_request(q_object, path, params)
  end

  def self.create(q_object:, user_id:, data:)
    expected_data_keys = %w[currency uid extra]
    raise ArgumentError, "data must include #{expected_data_keys}" unless data.keys.sort == expected_data_keys.sort

    path = "#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}"

    post_request(q_object, path, data)
  end

  def self.getAccount(q_object:, user_id:, beneficiary_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}/#{beneficiary_id}"

    get_request(q_object, path)
  end

  def self.editAccount(q_object:, user_id:, beneficiary_id:, data:)
    path = "#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}/#{beneficiary_id}"

    raise ArgumentError, "data must include a uid" unless data.include?("uid")

    put_request(q_object, path, data)
  end
end
