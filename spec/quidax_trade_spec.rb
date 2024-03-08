test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe QuidaxTrade do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_trade = QuidaxTrade.new(quidax_object)

  describe "for_user" do
    it "expects :user_id" do
      q_trade.for_user
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :user_id"
    end
    it "returns array of trades by user" do
      user_id = "me"
      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::TRADES_PATH}"

      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: [] }.to_json)
      trades_for_user_query = q_trade.for_user(user_id: user_id)
      trades_for_user = trades_for_user_query["data"]
      expect(trades_for_user).to be_a Array
    end
  end
  describe "for_market" do
    quidax_object = Quidax::Quidax.new(test_secret_key)
    q_trade = QuidaxTrade.new(quidax_object)

    it "expects :market" do
      q_trade.for_market
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :market"
    end
    it "returns array of trades for market" do
      market = "btcngn"
      url = "#{API::BASE_URL}#{API::TRADES_PATH}/#{market}"

      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: [] }.to_json)
      trades_for_market_pair_query = q_trade.for_market(market: market)
      trades_for_market_pair = trades_for_market_pair_query["data"]
      expect(trades_for_market_pair).to be_a Array
    end
  end
end
