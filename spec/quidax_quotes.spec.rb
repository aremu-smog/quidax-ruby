test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe QuidaxQuote do
  quidax_object = Quidax.new(test_secret_key)
  q_quotes = QuidaxQuote.new(quidax_object)

  it "expects :query" do
    q_quotes.get
  rescue StandardError => e
    expect(e.message).to eq "missing keyword: :query"
  end
  it ":query expects market, unit, kind, volume" do
    q_quotes.get(query: {})
  rescue StandardError => e
    expect(e.message).to eq "missing key(s) in :query market, unit, kind, volume"
  end
  it "query.kind should be ask, bid" do
    query = {
      market: "btcusdt",
      unit: "btc",
      kind: "assk",
      volume: "2"
    }
    q_quotes.get(query: query)
  rescue StandardError => e
    expect(e.message).to eq ':query["kind"] must be one of: ask, bid'
  end

  it "returns an Hash" do
    url = "#{API::BASE_URL}#{API::QUOTE_PATH}"

    query = {
      market: "btcusdt",
      unit: "btc",
      kind: "ask",
      volume: "2"
    }
    result = { data: QuotesMock::QDX_USDT_QUOTE }.to_json
    stub_request(:get, url).with(headers: test_headers, query: query).to_return(body: result)

    quotes_query = q_quotes.get(query: query)

    quotes = quotes_query["data"]

    expect(quotes).to be_a Hash
  end
end
