test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe "QuidaxTrade.forUser" do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_trade = QuidaxTrade.new(quidax_object)

  it "raises ArgumentError with no params" do
    q_trade.forUser
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "returns array of trades by user" do
    user_id = "me"
    url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::TRADES_PATH}"

    stub_request(:get, url).with(headers: test_headers).to_return(body: { data: [] }.to_json)
    trades_for_user_query = q_trade.forUser(user_id: user_id)
    trades_for_user = trades_for_user_query["data"]
    expect(trades_for_user.is_a?(Array)).to be true
  end
end
RSpec.describe "QuidaxTrade.forMarket" do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_trade = QuidaxTrade.new(quidax_object)

  it "raises ArgumentError with no params" do
    q_trade.forMarket
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "returns array of trades by user" do
    market_pair = "btc_ngn"
    url = "#{API::BASE_URL}#{API::TRADES_PATH}/#{market_pair}"

    stub_request(:get, url).with(headers: test_headers).to_return(body: { data: [] }.to_json)
    trades_for_market_pair_query = q_trade.forMarket(market_pair: market_pair)
    trades_for_market_pair = trades_for_market_pair_query["data"]
    expect(trades_for_market_pair.is_a?(Array)).to be true
  end
end
