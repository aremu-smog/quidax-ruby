# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe QuidaxBeneficiary do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_beneficiary = QuidaxBeneficiary.new(quidax_object)

  describe "getAll" do
    it "expects user_id, currency" do
      q_beneficiary.getAll
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :currency"
    end
    it "expects currency" do
      user_id = "me"
      q_beneficiary.getAll(user_id: user_id)
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :currency"
    end
    it "expects user_id" do
      currency = "btc"
      q_beneficiary.getAll(currency: currency)
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :user_id"
    end
    it "expects valid currency" do
      user_id = "me"
      currency = "meme"
      q_beneficiary.getAll(user_id: user_id, currency: currency)
    rescue StandardError => e
      expect(e.message).to eq "#{currency} is not allowed"
    end

    it "returns an array of beneficiary" do
      user_id = "me"
      currency = "btc"

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}"
      params = {
        currency: currency
      }

      stub_request(:get, url).with(headers: test_headers, query: params).to_return(body: { data: [] }.to_json)

      all_beneficiary_query = q_beneficiary.getAll(currency: currency, user_id: user_id)
      all_beneficiary = all_beneficiary_query["data"]
      expect(all_beneficiary).to be_a Array
    end
  end

  describe "create" do
    it "raises ArgumentError with no params" do
      q_beneficiary.create
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :data"
    end
    it "raises ArgumentError with user_id only" do
      user_id = "me"
      q_beneficiary.create(user_id: user_id)
    rescue StandardError => e
      expect(e.instance_of?(ArgumentError)).to eq true
    end
    it "raises ArgumentError with incorrect data hash" do
      user_id = "me"
      data = {
        currency: "btc",
        uid: "skljdljdl"
      }
      q_beneficiary.create(user_id: user_id, data: data)
    rescue StandardError => e
      expect(e.instance_of?(ArgumentError)).to eq true
    end
    it "returns beneficiary object " do
      user_id = "me"
      data = {
        "currency" => "btc",
        "uid" => "skljdljdl",
        "extra" => "Firstname Lastname"
      }

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}"
      stub_request(:post, url).with(
        body: data, headers: test_headers
      ).to_return(body: { data: {} }.to_json)

      new_beneficiary_query = q_beneficiary.create(user_id: user_id, data: data)
      new_beneficiary = new_beneficiary_query["data"]

      expect(new_beneficiary).to be_a Hash
    end
  end

  describe "getAccount" do
    it "expects user_id and beneficiary_id" do
      q_beneficiary.getAccount
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :beneficiary_id"
    end
    it "expects beneficiary_id" do
      user_id = "me"
      q_beneficiary.getAccount(user_id: user_id)
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :beneficiary_id"
    end
    it "expects user_id" do
      beneficiary_id = "1234"
      q_beneficiary.getAccount(beneficiary_id: beneficiary_id)
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :user_id"
    end

    it "returns Hash for account" do
      user_id = "me"
      beneficiary_id = "1234"

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}/#{beneficiary_id}"

      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: {} }.to_json)

      beneficiary_account_query = q_beneficiary.getAccount(user_id: user_id, beneficiary_id: beneficiary_id)
      beneficiary_account = beneficiary_account_query["data"]

      expect(beneficiary_account).to be_a Hash
    end
  end

  describe "editAccount" do
    it "expects user_id and beneficiary_id" do
      q_beneficiary.editAccount
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :beneficiary_id, :data"
    end
    it "expects beneficiary_id and data" do
      user_id = "me"
      q_beneficiary.editAccount(user_id: user_id)
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :beneficiary_id, :data"
    end
    it "expects user_id and data" do
      beneficiary_id = "1234"
      q_beneficiary.editAccount(beneficiary_id: beneficiary_id)
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :data"
    end

    it "returns Hash for account" do
      user_id = "me"
      beneficiary_id = "1234"

      data = {
        "uid" => "slkjsdlkjslkd"
      }

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::BENEFICIARY_PATH}/#{beneficiary_id}"

      stub_request(:put, url).with(headers: test_headers, body: data).to_return(body: { data: {} }.to_json)

      edited_beneficiary_account_query = q_beneficiary.editAccount(user_id: user_id, beneficiary_id: beneficiary_id,
                                                                   data: data)
      edited_beneficiary_account = edited_beneficiary_account_query["data"]

      expect(edited_beneficiary_account).to be_a Hash
    end
  end
end
