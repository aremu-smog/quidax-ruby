# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
wallet_fields = %w[id currency balance locked staked user converted_balance reference_currency
                   is_crypto created_at updated_at deposit_address destination_tag]
payment_address_fields = %w[id reference currency address destination_tag total_payments created_at
                            updated_at]
valid_address_fields = %w[currency address valid]

test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe QuidaxWallet do
  q_object = Quidax.new(test_secret_key)
  q_wallet = QuidaxWallet.new(q_object)

  describe "get_user_wallets" do
    it "expects :user_id" do
      q_wallet.get_user_wallets
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :user_id"
    end

    it "returns Hash" do
      user_id = "me"
      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}/wallets"
      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: WalletMock::ALL_WALLETS }.to_json)
      all_wallets_query = q_wallet.get_user_wallets(user_id: user_id)

      all_wallets = all_wallets_query["data"]
      expect(all_wallets).to be_a Array
    end
  end

  describe "get_user_wallet" do
    it "expects :user_id, :currency" do
      q_wallet.get_user_wallet
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :currency"
    end

    it "returns Hash" do
      user_id = "me"
      currency = "btc"
      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}"
      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: WalletMock::WALLET }.to_json)
      wallet_query = q_wallet.get_user_wallet(user_id: user_id, currency: currency)

      wallet = wallet_query["data"]
      expect(wallet).to be_a Hash
    end
  end

  describe "get_payment_address" do
    it "expect :user_id, :currency" do
      q_wallet.get_payment_address
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :currency"
    end

    it "returns Hash" do
      user_id = "me"
      currency = "btc"
      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}/address"
      stub_request(:get,
                   url).with(headers: test_headers).to_return(body: { data: WalletMock::PAYMENT_ADDRESS }.to_json)
      payment_address_query = q_wallet.get_payment_address(user_id: user_id, currency: currency)
      expect(payment_address_query["data"].nil?).to eq false

      payment_address = payment_address_query["data"]
      expect(payment_address).to be_a Hash
    end
  end

  describe "get_payment_address_by_id" do
    it "expects :user_id, :currency, :address_id" do
      q_wallet.get_payment_address_by_id
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :currency, :address_id"
    end

    it "returns Hash" do
      user_id = "me"
      currency = "btc"
      address_id = "34"
      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}/addresses/#{address_id}"

      stub_request(:get,
                   url).with(headers: test_headers).to_return(body: { data: WalletMock::PAYMENT_ADDRESS }.to_json)
      payment_address_query = q_wallet.get_payment_address_by_id(user_id: user_id, currency: currency,
                                                                 address_id: address_id)

      payment_address = payment_address_query["data"]
      expect(payment_address).to be_a Hash
    end
  end

  describe "get_payment_addresses" do
    it "expects :user_id, :currency" do
      q_wallet.get_payment_addresses
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :currency"
    end

    it "returns data for get_payment_addresses with params" do
      user_id = "me"
      currency = "btc"
      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}/addresses"
      stub_request(:get,
                   url).with(headers: test_headers).to_return(body: { data: WalletMock::ALL_BTC_PAYMENT_ADDRESS }.to_json)
      all_payment_address_query = q_wallet.get_payment_addresses(user_id: user_id, currency: currency)
      expect(all_payment_address_query["data"].nil?).to be false

      all_payment_address = all_payment_address_query["data"]
      expect(all_payment_address.is_a?(Array)).to be true
    end
  end

  describe "create_crypto_payment_address" do
    it "expects :user_id, :currency" do
      q_wallet.create_crypto_payment_address
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :currency"
    end

    it "returns Hash" do
      user_id = "me"
      currency = "btc"
      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}/addresses"

      stub_request(:post,
                   url).with(headers: test_headers).to_return(body: { data: WalletMock::NEW_PAYMENT_ADDRESS }.to_json)

      crypto_payment_address_query = q_wallet.create_crypto_payment_address(user_id: user_id, currency: currency)
      expect(crypto_payment_address_query["data"].nil?).to eq false

      crypto_payment_address = crypto_payment_address_query["data"]
      expect(crypto_payment_address.keys).to eq payment_address_fields
    end
  end

  describe "validate_address" do
    it "expects: :currency, :address " do
      q_wallet.validate_address
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :currency, :address"
    end

    it "returns Hash" do
      currency = "btc"
      address = "1Lbcfr7sAHTD9CgdQo3HTMTkV8LK4ZnX71"
      url = "#{API::BASE_URL}/#{currency}/#{address}/validate_address"

      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: WalletMock::VALID_ADDRESS }.to_json)
      valid_address_query = q_wallet.validate_address(currency: currency, address: address)

      valid_address = valid_address_query["data"]
      expect(valid_address).to be_a Hash
    end
  end
end
