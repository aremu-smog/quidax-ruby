
test_secret_key = ["TEST_SECRET_KEY"]
RSpec.describe QuidaxWallet do
    qObject = Quidax::Quidax.new(test_secret_key)
    qWallet = QuidaxWallet.new(qObject)
    it "returns ArgumentError for getAllWallets without account_id" do
        begin
            all_wallets_query = qWallet.getAllWallets
        rescue => e
            expect(e.instance_of? ArgumentError).to eq true
        end
    end

    it "returns data for getAllWallets with account_data" do
        all_wallets_query = qWallet.getAllWallets("me")
        expect(all_wallets_query.nil?).to eq false

        all_wallets = all_wallets_query["data"]
        expect(all_wallets.is_a?(Array)).to eq true
    end
end