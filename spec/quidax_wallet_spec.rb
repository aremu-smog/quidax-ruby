# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
wallet_fields = %w[id currency balance locked staked user converted_balance reference_currency
                   is_crypto created_at updated_at deposit_address destination_tag]
payment_address_fields = %w[id reference currency address destination_tag total_payments created_at
                            updated_at]
valid_address_fields = %w[currency address valid]

test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe QuidaxWallet do
  q_object = Quidax::Quidax.new(test_secret_key)
  q_wallet = QuidaxWallet.new(q_object)
  it "raises ArgumentError for getAllWallets without user_id" do
    q_wallet.getAllWallets
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "returns data for getAllWallets with user_id" do
    user_id = "me"
    url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}/wallets"
    stub_request(:get, url).with(headers: test_headers).to_return(body: { data: WalletMock::ALL_WALLETS }.to_json)
    all_wallets_query = q_wallet.getAllWallets(user_id)
    expect(all_wallets_query.nil?).to eq false

    all_wallets = all_wallets_query["data"]
    expect(all_wallets.is_a?(Array)).to eq true
  end

  it "raises ArgumentError for getWallet without any params" do
    q_wallet.getWallet
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "returns wallet address for getWallet with params" do
    user_id = "me"
    currency = "btc"
    url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}"
    stub_request(:get, url).with(headers: test_headers).to_return(body: { data: WalletMock::WALLET }.to_json)
    wallet_query = q_wallet.getWallet("me", "btc")
    expect(wallet_query["data"].nil?).to eq false

    wallet = wallet_query["data"]
    expect(wallet.keys.sort).to eq wallet_fields.sort
  end

  it "raises ArgumentError for getPaymentAddress without any params" do
    q_wallet.getPaymentAddress
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "returns payment address for getPaymentAddress with correct params" do
    user_id = "me"
    currency = "btc"
    url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}/address"
    stub_request(:get,
                 url).with(headers: test_headers).to_return(body: { data: WalletMock::PAYMENT_ADDRESS }.to_json)
    payment_address_query = q_wallet.getPaymentAddress(user_id, currency)
    expect(payment_address_query["data"].nil?).to eq false

    payment_address = payment_address_query["data"]
    expect(payment_address.keys).to eq payment_address_fields
  end

  it "raises ArgumentError for getAllPaymentAddress without params" do
    q_wallet.getAllPaymentAddress
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "returns data for getAllPaymentAddress with params" do
    user_id = "me"
    currency = "btc"
    url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}/addresses"
    stub_request(:get,
                 url).with(headers: test_headers).to_return(body: { data: WalletMock::ALL_BTC_PAYMENT_ADDRESS }.to_json)
    all_payment_address_query = q_wallet.getAllPaymentAddress(user_id, currency)
    expect(all_payment_address_query["data"].nil?).to be false

    all_payment_address = all_payment_address_query["data"]
    expect(all_payment_address.is_a?(Array)).to be true
  end

  it "raises ArgumentError for getPaymentAddressById without any params" do
    q_wallet.getPaymentAddressById
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "returns payment address for getPaymentAddressById with correct params" do
    user_id = "me"
    currency = "btc"
    address_id = "34"
    url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}/addresses/#{address_id}"

    stub_request(:get,
                 url).with(headers: test_headers).to_return(body: { data: WalletMock::PAYMENT_ADDRESS }.to_json)
    payment_address_query = q_wallet.getPaymentAddressById(user_id, currency, address_id)
    expect(payment_address_query["data"].nil?).to eq false

    payment_address = payment_address_query["data"]
    expect(payment_address.keys).to eq payment_address_fields
  end

  it "raises ArgumentError createCryptoPaymentAddress cr without any params" do
    q_wallet.createCryptoPaymentAddress
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "returns payment address for createCryptoPaymentAddress with correct params" do
    user_id = "me"
    currency = "btc"
    url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::WALLET_PATH}/#{currency}/addresses"

    stub_request(:post,
                 url).with(headers: test_headers).to_return(body: { data: WalletMock::NEW_PAYMENT_ADDRESS }.to_json)

    crypto_payment_address_query = q_wallet.createCryptoPaymentAddress(user_id, currency)
    expect(crypto_payment_address_query["data"].nil?).to eq false

    crypto_payment_address = crypto_payment_address_query["data"]
    expect(crypto_payment_address.keys).to eq payment_address_fields
  end

  it "raises ArgumentError for validateAddress without params " do
    q_wallet.validateAddress
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "returns data for validateAddress with params" do
    currency = "btc"
    address = "1Lbcfr7sAHTD9CgdQo3HTMTkV8LK4ZnX71"
    url = "#{API::BASE_URL}/#{currency}/#{address}/validate_address"

    stub_request(:get, url).with(headers: test_headers).to_return(body: { data: WalletMock::VALID_ADDRESS }.to_json)
    valid_address_query = q_wallet.validateAddress(currency, address)
    expect(valid_address_query["data"].nil?).to eq false

    valid_address = valid_address_query["data"]
    expect(valid_address.keys).to eq valid_address_fields
  end
end
