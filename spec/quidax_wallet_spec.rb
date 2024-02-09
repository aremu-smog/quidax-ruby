
test_secret_key = ["TEST_SECRET_KEY"]
wallet_fields = ["id","currency","balance","locked","staked","user","converted_balance","reference_currency","is_crypto","created_at","updated_at","deposit_address","destination_tag"]
payment_address_fields = ["id","reference","currency","address","destination_tag","total_payments","created_at","updated_at"]

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

    it "raises ArgumentError for getPaymentAddress without any params" do
        begin
            payment_address_query = qWallet.getPaymentAddress
        rescue => e
            expect(e.instance_of? ArgumentError).to eq true
        end
    end

    it "returns payment address for getPaymentAddress with correct params" do
        payment_address_query = qWallet.getPaymentAddress("me","btc")
        expect(payment_address_query["data"].nil?).to eq false

        payment_address = payment_address_query["data"]
        expect(payment_address.keys).to eq payment_address_fields
    end

    it "raises ArgumentError for getAllPaymentAddress without params" do
        begin
            all_payment_address_query = qWallet.getAllPaymentAddress
        rescue => e
            expect(e.instance_of? ArgumentError).to eq true
        end
    end

    it "returns wallet address for getAllPaymentAddress with params" do
        all_payment_address_query = qWallet.getAllPaymentAddress("me","btc")
        expect(all_payment_address_query["data"].nil?).to be false

        all_payment_address = all_payment_address_query["data"]
        expect(all_payment_address.is_a?(Array)).to be true
    end

    it "raises ArgumentError for getPaymentAddressById without any params" do
        begin
            payment_address_query = qWallet.getPaymentAddressById
        rescue => e
            expect(e.instance_of? ArgumentError).to eq true
        end
    end

    it "returns payment address for getPaymentAddressById with correct params" do
        payment_address_query = qWallet.getPaymentAddressById("me","btc","123")
        expect(payment_address_query["data"].nil?).to eq false

        payment_address = payment_address_query["data"]
        expect(payment_address.keys).to eq payment_address_fields
    end

    it "raises ArgumentError createCryptoPaymentAddress cr without any params" do
        begin
            payment_address_query = qWallet.createCryptoPaymentAddress
        rescue => e
            expect(e.instance_of? ArgumentError).to eq true
        end
    end

    it "returns payment address for createCryptoPaymentAddress with correct params" do
        crypto_payment_address_query = qWallet.getPaymentAddressById("me","btc")
        expect(crypto_payment_address_query["data"].nil?).to eq false

        crypto_payment_address = crypto_payment_address_query["data"]
        expect(crypto_payment_address.keys).to eq payment_address_fields
    end


end