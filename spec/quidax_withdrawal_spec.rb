# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe "QuidaxWithdrawal" do
  q_object = Quidax::Quidax.new(test_secret_key)
  q_withdrawal = QuidaxWithdrawal.new(q_object)

  describe "get_all_withdrawals_detail" do
    it "expects :user_id, :query" do
      q_withdrawal.get_all_withdrawals_detail
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :query"
    end
    it "expects :query to have currency, state" do
      q_withdrawal.get_all_withdrawals_detail(user_id: "me", query: {})
    rescue StandardError => e
      expect(e.message).to eq "missing key(s) in :query currency, state"
    end

    it "returns Array" do
      user_id = "2"
      query = { state: "pend", currency: "btc" }

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::WITHDRAWAL_PATH}"

      result = { data: WithdrawalMock::ALL_BTC_WITHDRAWAL_DETAILS }.to_json

      stub_request(:get, url).with(headers: test_headers,
                                   query: query).to_return(body: result)

      all_withdrawals_detail_query = q_withdrawal.get_all_withdrawals_detail(user_id: user_id, query: query)

      all_withdrawals_detail = all_withdrawals_detail_query["data"]
      expect(all_withdrawals_detail).to be_a Array
    end
  end

  describe "get_detail" do
    q_object = Quidax::Quidax.new(test_secret_key)
    q_withdrawal = QuidaxWithdrawal.new(q_object)

    it "expects :user_id, :withdrawal_id" do
      q_withdrawal.get_detail
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :withdrawal_id"
    end

    it "returns Hash" do
      user_id = "me"
      withdrawal_id = "2345"

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::WITHDRAWAL_PATH}/#{withdrawal_id}"
      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: WithdrawalMock::WITHDRAWAL }.to_json)

      withdrawal_detail_query = q_withdrawal.get_detail(user_id: user_id, withdrawal_id: withdrawal_id)

      wallet_detail = withdrawal_detail_query["data"]
      expect(wallet_detail).to be_a Hash
    end
  end
  describe "cancel" do
    q_object = Quidax::Quidax.new(test_secret_key)
    q_withdrawal = QuidaxWithdrawal.new(q_object)
    withdrawal_id = "12334"
    it "expects :withdrawal_id" do
      q_withdrawal.cancel
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :withdrawal_id"
    end

    it "cancels a withdrawal with params" do
      url = "#{API::BASE_URL}#{API::USER_PATH}/me#{API::WITHDRAWAL_PATH}/#{withdrawal_id}/cancel"

      stub_request(:post,
                   url).with(headers: test_headers).to_return(body: { data: WithdrawalMock::CANCELLED_WITHDRAWAL }.to_json)

      cancel_withdrawal_query = q_withdrawal.cancel(withdrawal_id: withdrawal_id)

      expect(cancel_withdrawal_query["data"]).to be_a Hash
    end
  end
end
