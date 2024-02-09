

test_secret_key = ENV['TEST_SECRET_KEY']
account_fields = ["id","sn","email","reference","first_name","last_name","display_name","created_at","updated_at"]


RSpec.describe QuidaxUser do
    quidax_object = Quidax::Quidax.new(test_secret_key)
    qUser = QuidaxUser.new(quidax_object)

    test_headers = {"Authorization": "Bearer #{test_secret_key}"}

    it "raises ArgumentError for account details without id" do
        begin
            account_query = qUser.getAccountDetails
        rescue => e
            expect(e.instance_of? ArgumentError).to eq true
        end

    end
    it "should return user account details object" do

        url = "#{API::BASE_URL}#{API::USER_PATH}/me"
        stub_request(:get,url ).with(headers:test_headers ).to_return(body: {data: UserMock::ACCOUNT}.to_json)

        account_query = qUser.getAccountDetails("me")
        expect(account_query.nil?).to eq false

        account_details = account_query["data"]
        account_detail_fields = account_details.keys
        expect(account_detail_fields).to eq account_fields
    end

    it "gets all subaccounts" do
        url = "#{API::BASE_URL}#{API::USER_PATH}"
        stub_request(:get, url).with(headers:  test_headers).to_return(body: {data: UserMock::ALL_SUBACCOUNTS}.to_json)
        all_subaccounts_query = qUser.getAllSubAccounts
        expect(all_subaccounts_query.nil?).to eq false

        all_subaccounts = all_subaccounts_query["data"]
        expect(all_subaccounts.is_a?(Array)).to eq true
    end

    it "raises ArgumentError for createSubAcccount without data" do
        begin
            new_subaccount_query = qUser.createSubAcccount
        rescue => e
            expect(e.instance_of? ArgumentError).to eq true
        end
    end

    it "should createSubAccount" do
        url = "#{API::BASE_URL}#{API::USER_PATH}"
        stub_request(:post, url).with(headers: test_headers).to_return(body: {data: UserMock::ACCOUNT}.to_json)
        new_subaccount_query = qUser.createSubAcccount(UserMock::NEW_USER)
        expect(new_subaccount_query.nil?).to eq false

        new_subaccount = new_subaccount_query["data"]
        expect(new_subaccount.keys).to eq account_fields
    end

    it "raises ArgumentError for editSubAccount without account_id, and data" do
        begin
            update_subaccount_query = qUser.editAccount
        rescue => e
            expect(e.instance_of? ArgumentError).to eq true
        end
    end
    it "should editAccount with account_id and data" do
        url = "#{API::BASE_URL}#{API::USER_PATH}/me"
        stub_request(:put, url).with(headers: test_headers).to_return(body: {data: UserMock::UPDATED_ACCOUNT}.to_json)
           
        update_subaccount_query = qUser.editAccount("me", UserMock::UPDATE_INFO)
        expect(update_subaccount_query.nil?).to eq false

        updated_subaccount = update_subaccount_query["data"]
        expect(updated_subaccount.keys).to eq account_fields
 
    end
end