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
