# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe QuidaxBeneficiary do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_beneficiary = QuidaxBeneficiary.new(quidax_object)

  describe "get_all" do
    it "expects user_id, query" do
      q_beneficiary.get_all
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :query"
    end
    it "expects valid currency" do
      user_id = "me"
      query = {
        currency: "meme"
      }
      q_beneficiary.get_all(user_id: user_id, query: query)
    rescue StandardError => e
      expect(e.message).to eq ":currency must be one of: btc, ltc, xrp, dash, trx, doge"
    end

    it "returns an array of beneficiary" do
      user_id = "me"

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}"
      query = {
        currency: "btc"
      }

      stub_request(:get, url).with(headers: test_headers, query: query).to_return(body: { data: [] }.to_json)

      all_beneficiary_query = q_beneficiary.get_all(user_id: user_id, query: query)
      all_beneficiary = all_beneficiary_query["data"]
      expect(all_beneficiary).to be_a Array
    end
  end

  describe "create" do
    it "expects user_id:, body:" do
      q_beneficiary.create
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :body"
    end
    it "expects :body to have currency, uid, extra" do
      user_id = "me"
      q_beneficiary.create(user_id: user_id, body: {})
    rescue StandardError => e
      expect(e.message).to eq "missing key(s) in :body currency, uid, extra"
    end
    it "returns hash " do
      user_id = "me"
      body = {
        currency: "btc",
        uid: "skljdljdl",
        extra: "Firstname Lastname"
      }

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}"
      stub_request(:post, url).with(
        body: body, headers: test_headers
      ).to_return(body: { data: {} }.to_json)

      new_beneficiary_query = q_beneficiary.create(user_id: user_id, body: body)
      new_beneficiary = new_beneficiary_query["data"]

      expect(new_beneficiary).to be_a Hash
    end
  end

  describe "get_account" do
    it "expects user_id and beneficiary_id" do
      q_beneficiary.get_account
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :beneficiary_id"
    end

    it "returns Hash" do
      user_id = "me"
      beneficiary_id = "1234"

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}/#{beneficiary_id}"

      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: {} }.to_json)

      beneficiary_account_query = q_beneficiary.get_account(user_id: user_id, beneficiary_id: beneficiary_id)
      beneficiary_account = beneficiary_account_query["data"]

      expect(beneficiary_account).to be_a Hash
    end
  end

  describe "edit_account" do
    it "expects user_id:, beneficiary_id:, body:" do
      q_beneficiary.edit_account
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :beneficiary_id, :body"
    end

    it "returns Hash for account" do
      user_id = "me"
      beneficiary_id = "1234"

      body = {
        uid: "slkjsdlkjslkd"
      }

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}/#{beneficiary_id}"

      stub_request(:put, url).with(headers: test_headers, body: body).to_return(body: { data: {} }.to_json)

      edited_beneficiary_account_query = q_beneficiary.edit_account(user_id: user_id, beneficiary_id: beneficiary_id,
                                                                    body: body)
      edited_beneficiary_account = edited_beneficiary_account_query["data"]

      expect(edited_beneficiary_account).to be_a Hash
    end
  end
end
