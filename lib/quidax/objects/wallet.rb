# frozen_string_literal: true

# Object for wallet related actions
class QuidaxWallet < QuidaxBaseObject
  def get_user_wallets(user_id:)
    QuidaxWallet.get_user_wallets(q_object: @quidax, user_id: user_id)
  end

  def get_user_wallet(user_id:, currency:)
    QuidaxWallet.get_user_wallet(q_object: @quidax, user_id: user_id, currency: currency)
  end

  def get_payment_address(user_id:, currency:)
    QuidaxWallet.get_payment_address(q_object: @quidax, user_id: user_id, currency: currency)
  end

  def get_payment_address_by_id(user_id:, currency:, address_id:)
    QuidaxWallet.get_payment_address_by_id(q_object: @quidax, user_id: user_id, currency: currency,
                                           address_id: address_id)
  end

  def get_payment_addresses(user_id:, currency:)
    QuidaxWallet.get_payment_addresses(q_object: @quidax, user_id: user_id, currency: currency)
  end

  def create_crypto_payment_address(user_id:, currency:)
    QuidaxWallet.create_crypto_payment_address(q_object: @quidax, user_id: user_id, currency: currency)
  end

  def validate_address(currency:, address:)
    QuidaxWallet.validate_address(q_object: @quidax, currency: currency, address: address)
  end

  def self.get_user_wallets(q_object:, user_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}"
    get_request(q_object, path)
  end

  def self.get_user_wallet(q_object:, user_id:, currency:)
    path = "#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}"
    get_request(q_object, path)
  end

  def self.get_payment_address(q_object:, user_id:, currency:)
    path = "#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}/address"
    get_request(q_object, path)
  end

  def self.get_payment_address_by_id(q_object:, user_id:, currency:, address_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}/addresses/#{address_id}"
    get_request(q_object, path)
  end

  def self.get_payment_addresses(q_object:, user_id:, currency:)
    path = "#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}/addresses"
    get_request(q_object, path)
  end

  def self.create_crypto_payment_address(q_object:, user_id:, currency:)
    path = "#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}/addresses"
    post_request(q_object, path)
  end

  def self.validate_address(q_object:, currency:, address:)
    path = "/#{currency}/#{address}/validate_address"
    get_request(q_object, path)
  end
end
