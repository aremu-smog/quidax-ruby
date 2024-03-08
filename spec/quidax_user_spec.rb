# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
account_fields = %w[id sn email reference first_name last_name display_name created_at updated_at]

RSpec.describe QuidaxUser do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  quidax_user = QuidaxUser.new(quidax_object)

  test_headers = { "Authorization": "Bearer #{test_secret_key}" }
  describe "get_account_details" do
    it "expects account_id:" do
      quidax_user.get_account_details
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :user_id"
    end
    it "returns Hash" do
      user_id = "me"
      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}"
      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: UserMock::ACCOUNT }.to_json)

      account_query = quidax_user.get_account_details(user_id: user_id)
      expect(account_query.nil?).to eq false

      account_details = account_query["data"]

      expect(account_details).to be_a Hash
    end
  end

  describe "create_sub_account" do
    it "expects :body" do
      quidax_user.create_sub_account
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :body"
    end
    it "expects :body to have email, first_name, last_name, phone_number" do
      quidax_user.create_sub_account(body: {})
    rescue StandardError => e
      expect(e.message).to eq "missing key(s) in :body email, first_name, last_name, phone_number"
    end

    it "returns Hash" do
      url = "#{API::BASE_URL}#{API::USER_PATH}"
      stub_request(:post, url).with(headers: test_headers).to_return(body: { data: UserMock::ACCOUNT }.to_json)
      new_subaccount_query = quidax_user.create_sub_account(body: UserMock::NEW_USER)

      new_subaccount = new_subaccount_query["data"]
      expect(new_subaccount).to be_a Hash
    end
  end

  describe "get_all_subaccounts" do
    it "returns Array" do
      url = "#{API::BASE_URL}#{API::USER_PATH}"
      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: UserMock::ALL_SUBACCOUNTS }.to_json)
      all_subaccounts_query = quidax_user.get_all_sub_accounts

      all_subaccounts = all_subaccounts_query["data"]
      expect(all_subaccounts).to be_a Array
    end
  end

  describe "edit_account" do
    it "expects :user_id, :body" do
      quidax_user.edit_account
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :body"
    end

    it "returns Hash" do
      url = "#{API::BASE_URL}#{API::USER_PATH}/me"
      response_body = { data: UserMock::UPDATED_ACCOUNT }.to_json
      stub_request(:put, url).with(headers: test_headers,
                                   body: UserMock::UPDATE_INFO).to_return(body: response_body)

      update_subaccount_query = quidax_user.edit_account(user_id: "me", body: UserMock::UPDATE_INFO)

      updated_subaccount = update_subaccount_query["data"]
      expect(updated_subaccount).to be_a Hash
    end
  end
end
