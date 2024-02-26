test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe QuidaxQuote do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_quotes = QuidaxQuote.new(quidax_object)

  it "raises ArgumentError with no params" do
    q_quotes.get
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError with only market" do
    q_quotes.get(market: "qdxusdt")
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError with only market and unit" do
    q_quotes.get(market: "qdxusdt", unit: "qdx")
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError with only market, unit, and kind" do
    q_quotes.get(market: "qdxusdt", unit: "qdx", kind: "ask")
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError with ask not ask or bid" do
    q_quotes.get(market: "qdxusdt", unit: "qdx", kind: "sample", volume: "2")
  rescue StandardError => e
    expect(e.message).to eq "kind should be ask or bid"
  end

  it "returns object with correct params" do
    url = "#{API::BASE_URL}#{API::QUOTE_PATH}"
    market = "qdxusdt"
    unit = "qdx"
    kind = "ask"
    volume = "2"
    params = {
      market: market,
      unit: unit,
      kind: kind,
      volume: volume
    }
    result = { data: QuotesMock::QDX_USDT_QUOTE }.to_json
    stub_request(:get, url).with(headers: test_headers, query: params).to_return(body: result)

    quotes_query = q_quotes.get(market: market, unit: unit, kind: kind, volume: volume)

    expect(quotes_query["data"].nil?).to eq false
    quotes = quotes_query["data"]

    expect(quotes.keys).to eq %w[price total volume fee receive]
  end
end
