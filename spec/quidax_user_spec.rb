# require "quidax/objects/user.rb"
test_secret_key = ENV['TEST_SECRET_KEY']
account_fields = ["id","sn","email","reference","first_name","last_name","display_name","created_at","updated_at"]
RSpec.describe QuidaxUser do
    quidax_object = Quidax::Quidax.new(test_secret_key)
    qUser = QuidaxUser.new(quidax_object)

    it "raises ArgumentError for account details without id" do
        begin
            account_query = qUser.getAccountDetails
        rescue => e
            expect(e.instance_of? ArgumentError).to eq true
        end

    end
    it "should return user account details object" do

        account_query = qUser.getAccountDetails("me")
        expect(account_query.nil?).to eq false

        account_details = account_query["data"]
        account_detail_fields = account_details.keys
        expect(account_detail_fields).to eq account_fields
    end

    it "gets all subaccounts" do
        all_subaccounts_query = qUser.getAllSubAccounts
        expect(all_subaccounts_query.nil?).to eq false

        all_subaccounts = all_subaccounts_query["data"]
        expect(all_subaccounts.is_a?(Array)).to eq true
    end
end