# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe QuidaxDeposits do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_deposits = QuidaxDeposits.new(quidax_object)

  describe "by_user" do
    it "expects :user_id, :query" do
      q_deposits.by_user
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :query"
    end
    it "expects :query to have state, and currency" do
      q_deposits.by_user(user_id: "me", query: {})
    rescue StandardError => e
      expect(e.message).to eq "missing key(s) in :query currency, state"
    end
    it "expects a valid :state" do
      query = {
        currency: "btc",
        state: "submit"
      }
      q_deposits.by_user(user_id: "me", query: query)
    rescue StandardError => e
      allowed_states = "submitting, canceled, submitted, rejected, failed, accepted, checked"
      expect(e.message).to eq ":state must be one of: #{allowed_states}"
    end
    it "returns an array" do
      user_id = "me"
      query = {
        currency: "btc",
        state: "submitted"
      }

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}/#{API::DEPOSIT_PATH}"
      stub_request(:get, url).with(headers: test_headers, query: query).to_return(body: { data: [] }.to_json)

      deposits_by_user_query = q_deposits.by_user(user_id: user_id, query: query)
      deposits_by_user = deposits_by_user_query["data"]
      expect(deposits_by_user).to be_a Array
    end
  end
  describe "get_a_deposit" do
    it "expects user_id:, deposit_id:" do
      q_deposits.get_a_deposit
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :deposit_id"
    end

    it "returns Hash" do
      user_id = "me"
      deposit_id = "122345"

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::DEPOSIT_PATH}/#{deposit_id}"

      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: DepositMock::A_DEPOSIT }.to_json)

      a_deposit_query = q_deposits.get_a_deposit(user_id: user_id, deposit_id: deposit_id)
      a_deposit = a_deposit_query["data"]

      expect(a_deposit).to be_a Hash
    end
  end
  describe "by_sub_users" do
    it "returns array" do
      url = "#{API::BASE_URL}#{API::USER_PATH}#{API::DEPOSIT_PATH}/all"

      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: [] }.to_json)

      deposits_by_sub_users_query = q_deposits.by_sub_users
      deposits_by_sub_users = deposits_by_sub_users_query["data"]
      expect(deposits_by_sub_users).to be_a Array
    end
  end
end
