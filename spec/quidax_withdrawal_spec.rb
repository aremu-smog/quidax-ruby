# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe "QuidaxWithdrawal.getAllWithdrawalsDetail" do
  q_object = Quidax::Quidax.new(test_secret_key)
  q_withdrawal = QuidaxWithdrawal.new(q_object)

  it "raises ArgumentError getAllWithdrawalsDetail for no params" do
    q_withdrawal.getAllWithdrawalsDetail
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError getAllWithdrawalsDetail for incomplete params" do
    q_withdrawal.getAllWithdrawalsDetail(currency: "2", state: "pend")
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError getAllWithdrawalsDetail unrecongnized keyword param" do
    q_withdrawal.getAllWithdrawalsDetail(currency: "2", status: "pending")
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError getAllWithdrawalsDetail for too many params" do
    q_withdrawal.getAllWithdrawalsDetail("2", "pend", "btc", "hodl")
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "returns data for getAllWithdrawalsDetail with wrong parameters " do
    user_id = "2"
    state = "pend"
    currency = "btc"
    url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::WITHDRAWAL_PATH}"

    query = { state: state, currency: currency }
    result = { data: WithdrawalMock::ALL_BTC_WITHDRAWAL_DETAILS }.to_json

    stub_request(:get, url).with(headers: test_headers,
                                 query: query).to_return(body: result)

    all_withdrawals_detail_query = q_withdrawal.getAllWithdrawalsDetail(user_id: user_id, currency: currency,
                                                                        state: state)

    expect(all_withdrawals_detail_query["data"].nil?).to eq false

    all_withdrawals_detail = all_withdrawals_detail_query["data"]
    expect(all_withdrawals_detail.is_a?(Array)).to eq true
  end
end

# frozen_string_literal: true

RSpec.describe "QuidaxWithdrawal.getWithdrawalDetail" do
  q_object = Quidax::Quidax.new(test_secret_key)
  q_withdrawal = QuidaxWithdrawal.new(q_object)

  withdrawal_detail_fields = %w[id reference type currency amount fee total txid transaction_note
                                narration status reason created_at done_at recipient wallet user]

  it "raises ArgumentError for no params" do
    q_withdrawal.getWithdrawalDetail
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError for unrecognized param" do
    q_withdrawal.getWithdrawalDetail(user_id: "1", withdrawal_id: "123", name: "smog")
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError for incomplete params" do
    q_withdrawal.getWithdrawalDetail(user_id: "1")
    q_withdrawal.getWithdrawalDetail(withdrawal_id: "233")
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "returns withdrawal object with correct params" do
    user_id = "me"
    withdrawal_id = "2345"

    url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::WITHDRAWAL_PATH}/#{withdrawal_id}"
    stub_request(:get, url).with(headers: test_headers).to_return(body: { data: WithdrawalMock::WITHDRAWAL }.to_json)

    withdrawal_detail_query = q_withdrawal.getWithdrawalDetail(user_id: user_id, withdrawal_id: withdrawal_id)

    expect(withdrawal_detail_query["data"].nil?).to eq false
    wallet_detail = withdrawal_detail_query["data"]
    expect(wallet_detail.keys).to eq withdrawal_detail_fields
  end
end

RSpec.describe "QuidaxWithdrawal.cancelWithdrawal" do
  q_object = Quidax::Quidax.new(test_secret_key)
  q_withdrawal = QuidaxWithdrawal.new(q_object)
  withdrawal_id = "12334"
  it "raises ArgumentError for no params" do
    q_withdrawal.cancelWithdrawal
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "cancels a withdrawal with params" do
    url = "#{API::BASE_URL}#{API::USER_PATH}/me#{API::WITHDRAWAL_PATH}/#{withdrawal_id}/cancel"

    stub_request(:post,
                 url).with(headers: test_headers).to_return(body: { data: WithdrawalMock::CANCELLED_WITHDRAWAL }.to_json)

    cancel_withdrawal_query = q_withdrawal.cancelWithdrawal(withdrawal_id: withdrawal_id)

    expect(cancel_withdrawal_query["data"].nil?).to eq false
  end
end
