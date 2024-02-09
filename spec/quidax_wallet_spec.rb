
test_secret_key = ["TEST_SECRET_KEY"]
wallet_fields = ["id","currency","balance","locked","staked","user","converted_balance","reference_currency","is_crypto","created_at","updated_at","deposit_address","destination_tag"]
RSpec.describe QuidaxWallet do
    qObject = Quidax::Quidax.new(test_secret_key)
    qWallet = QuidaxWallet.new(qObject)
    it "raises ArgumentError for getAllWallets without account_id" do
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

    it "raises ArgumentError for getWallet without any params" do
        begin
            wallet_query = qWallet.getWallet
        rescue => e
            expect(e.instance_of? ArgumentError).to eq true
        end
    end

    it "returns wallet address for getWallet with params" do
        wallet_query = qWallet.getWallet("me","btc")
        expect(wallet_query["data"].nil?).to eq false
        
        wallet = wallet_query["data"]
        expect(wallet.keys).to eq wallet_fields
    end

end