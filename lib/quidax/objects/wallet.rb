# frozen_string_literal: true

# Object for wallet related actions
class QuidaxWallet < QuidaxBaseObject
  def getAllWallets(account_id)
    QuidaxWallet.getAllWallets(@quidax, account_id)
  end

  def getWallet(account_id, currency)
    QuidaxWallet.getWallet(@quidax, account_id, currency)
  end

  def getPaymentAddress(account_id, currency)
    QuidaxWallet.getPaymentAddress(@quidax, account_id, currency)
  end

  def getPaymentAddressById(account_id, currency, address_id)
    QuidaxWallet.getPaymentAddressById(@quidax, account_id, currency, address_id)
  end

  def getAllPaymentAddress(account_id, currency)
    QuidaxWallet.getAllPaymentAddress(@quidax, account_id, currency)
  end

  def createCryptoPaymentAddress(account_id, currency)
    QuidaxWallet.createCryptoPaymentAddress(@quidax, account_id, currency)
  end

  def validateAddress(currency, address)
    QuidaxWallet.validateAddress(@quidax, currency, address)
  end

  def self.getAllWallets(qObject, account_id)
    path = "#{API::USER_PATH}/#{account_id}#{API::WALLET_PATH}"
    get_request(qObject, path)
  end

  def self.getWallet(qObject, account_id, currency)
    path = "#{API::USER_PATH}/#{account_id}#{API::WALLET_PATH}/#{currency}"
    get_request(qObject, path)
  end

  def self.getPaymentAddress(qObject, account_id, currency)
    path = "#{API::USER_PATH}/#{account_id}#{API::WALLET_PATH}/#{currency}/address"
    get_request(qObject, path)
  end

  def self.getPaymentAddressById(qObject, account_id, currency, address_id)
    path = "#{API::USER_PATH}/#{account_id}#{API::WALLET_PATH}/#{currency}/addresses/#{address_id}"
    get_request(qObject, path)
  end

  def self.getAllPaymentAddress(qObject, account_id, currency)
    path = "#{API::USER_PATH}/#{account_id}#{API::WALLET_PATH}/#{currency}/addresses"
    get_request(qObject, path)
  end

  def self.createCryptoPaymentAddress(qObject, account_id, currency)
    path = "#{API::USER_PATH}/#{account_id}#{API::WALLET_PATH}/#{currency}/addresses"
    post_request(qObject, path)
  end

  def self.validateAddress(qObject, currency, address)
    path = "/#{currency}/#{address}/validate_address"
    get_request(qObject, path)
  end
end
