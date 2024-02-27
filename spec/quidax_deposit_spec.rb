# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe "QuidaxDeposit.getDepositsByUser" do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_deposit = QuidaxDeposit.new(quidax_object)

  it "raises ArgumentError with no params" do
    q_deposit.getDepositsByUser
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError with only currency" do
    currency = "btc"
    q_deposit.getDepositsByUser(currency: currency)
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError with only user and currency" do
    currency = "btc"
    user = "me"
    q_deposit.getDepositsByUser(user: user, currency: currency)
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError for unrecongized state" do
    currency = "btc"
    user = "me"
    state = "submit"
    q_deposit.getDepositsByUser(user: user, currency: currency, state: state)
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "returns array of deposits" do
    currency = "btc"
    user = "me"
    state = "submitted"

    url = "#{API::BASE_URL}#{API::USER_PATH}/#{user}/#{API::DEPOSIT_PATH}"
    params = {
      currency: currency,
      state: state
    }

    stub_request(:get, url).with(headers: test_headers, query: params).to_return(body: { data: [] }.to_json)

    deposits_by_user_query = q_deposit.getDepositsByUser(user: user, currency: currency, state: state)
    deposits_by_user = deposits_by_user_query["data"]
    expect(deposits_by_user.is_a?(Array)).to be true
  end
end

RSpec.describe "QuidaxDeposit.getADeposit" do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_deposit = QuidaxDeposit.new(quidax_object)

  it "raises ArgumentError with no params" do
    q_deposit.getADeposit
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError with only user_id" do
    user_id = "me"

    q_deposit.getADeposit(user_id: user_id)
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError with only deposit_id" do
    deposit_id = "122345"
    q_deposit.getADeposit(deposit_id: deposit_id)
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "returns deposit object" do
    user_id = "me"
    deposit_id = "122345"

    url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::DEPOSIT_PATH}/#{deposit_id}"

    stub_request(:get, url).with(headers: test_headers).to_return(body: { data: DepositMock::A_DEPOSIT }.to_json)

    a_deposit_query = q_deposit.getADeposit(user_id: user_id, deposit_id: deposit_id)
    a_deposit = a_deposit_query["data"]
    deposit_keys = %w[id type currency amount fee txid status reason created_at done_at wallet user
                      payment_transaction payment_address]
    expect(a_deposit.keys).to eq deposit_keys
  end
end

RSpec.describe "QuidaxDeposit.getDepositsBySubUsers" do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_deposit = QuidaxDeposit.new(quidax_object)

  it "returns array of all deposits by sub-users" do
    url = "#{API::BASE_URL}#{API::USER_PATH}#{API::DEPOSIT_PATH}/all"
    stub_request(:get, url).with(headers: test_headers).to_return(body: { data: [] }.to_json)
    deposits_by_sub_users_query = q_deposit.getDepositsBySubUsers
    deposits_by_sub_users = deposits_by_sub_users_query["data"]
    expect(deposits_by_sub_users.is_a?(Array)).to eq true
  end
end
