# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

market_ticker_keys = %w[at ticker market]

RSpec.describe QuidaxMarkets do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_markets = QuidaxMarkets.new(quidax_object)

  it "getAllMarkets return markets object" do
    url = "#{API::BASE_URL}#{API::MARKET_PATH}"
    stub_request(:get, url).with(headers: test_headers).to_return(body: { data: MarketsMock::ALL_MARKETS }.to_json)

    all_markets_query = q_markets.getAllMarkets
    expect(all_markets_query["data"].nil?).to eq false

    all_markets_data = all_markets_query["data"]
    expect(all_markets_data.size).to be > 0
  end

  it "getAllMarketTickers returns all market tickers object" do
    url = "#{API::BASE_URL}#{API::MARKET_PATH}/tickers"

    stub_request(:get,
                 url).with(headers: test_headers).to_return(body: { data: MarketsMock::ALL_MARKET_TICKERS }.to_json)

    all_market_tickers_query = q_markets.getAllMarketTickers

    expect(all_market_tickers_query["data"].nil?).to eq false

    all_market_tickers = all_market_tickers_query["data"]
    expect(all_market_tickers.keys.size).to be > 0
  end

  it "raises ArgumentError getMarketTicker with no params" do
    q_markets.getMarketTicker
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "getMarketTicker returns ticker for currency pair" do
    currency_pair = "qdxusdt"
    url = "#{API::BASE_URL}#{API::MARKET_PATH}/tickers/#{currency_pair}"

    stub_request(:get,
                 url).with(headers: test_headers).to_return(body: { data: MarketsMock::QDX_USDT_MARKET_TICKER }.to_json)

    market_ticker_query = q_markets.getMarketTicker(currency: currency_pair)

    expect(market_ticker_query["data"].nil?).to be false

    market_ticker = market_ticker_query["data"]
    expect(market_ticker.keys).to eq market_ticker_keys
  end

  it "raises ArgumentError for getKlineForMarket with no params" do
    q_markets.getKlineForMarket
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "raises ArgumentError getKlineForMarket with limit > 10_000" do
    market = "qdxusdt"
    limit = 10_001
    q_markets.getKlineForMarket(market: market, limit: limit)
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError getKlineForMarket with limit < 0" do
    market = "qdxusdt"
    limit = -1
    q_markets.getKlineForMarket(market: market, limit: limit)
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError getKlineForMarket with period not in range" do
    market = "qdxusdt"
    limit = 101
    period = 4
    q_markets.getKlineForMarket(market: market, limit: limit, period: period)
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "getKlineForMarket returns kLine data for market" do
    market = "qdxusdt"
    url = "#{API::BASE_URL}#{API::MARKET_PATH}/#{market}/k"
    query = {
      limit: 30,
      period: 1
    }
    result = {
      data: MarketsMock::QDX_USDT_MARKET_KLINE
    }.to_json

    stub_request(:get,
                 url).with(headers: test_headers, query: query).to_return(body: result)

    kline_for_market_query = q_markets.getKlineForMarket(market: market)

    expect(kline_for_market_query["data"].nil?).to eq false
    kline_for_market = kline_for_market_query["data"]

    expect(kline_for_market.all? { |item| item.is_a?(Float) }).to eq true
  end

  it "raises ArgumentError for getKlineWithPendingTrades with no params" do
    q_markets.getKlineWithPendingTrades
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError for getKlineWithPendingTrades with only currency" do
    currency = "qdxusdt"
    q_markets.getKlineWithPendingTrades(currency: currency)
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError for getKlineWithPendingTrades with only trade_id" do
    trade_id = "3"
    q_markets.getKlineWithPendingTrades(trade_id: trade_id)
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "getKlineWithPendingTrades returns kLine data for currency and trade_id" do
    currency = "qdxusdt"
    trade_id = "3"

    url = "#{API::BASE_URL}#{API::MARKET_PATH}/#{currency}/k_with_pending_trades/#{trade_id}"

    result = { data: MarketsMock::QDX_USDT_K_WITH_PENDING_TRADES }.to_json

    stub_request(:get, url).with(headers: test_headers).to_return(body: result)

    k_with_pending_trades_query = q_markets.getKlineWithPendingTrades(currency: currency, trade_id: trade_id)

    expect(k_with_pending_trades_query["data"].nil?).to eq false

    k_with_pending_trades = k_with_pending_trades_query["data"]

    expect(k_with_pending_trades["k"].all? { |item| item.is_a?(Float) }).to eq true

    expect(k_with_pending_trades["trades"].size).to be > 0
  end
end

RSpec.describe "QuidaxMarkets.getOrderBookItemsForMarket" do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_markets = QuidaxMarkets.new(quidax_object)

  it "raises ArgumentError for getOrderBookItemsForMarket without params" do
    q_markets.getOrderBookItemsForMarket
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "raises ArgumentError for getOrderBookItemsForMarket ask_limit > 200" do
    currency = "qdxusdt"
    ask_limit = "201"
    q_markets.getOrderBookItemsForMarket(currency: currency, ask_limit: ask_limit)
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "raises ArgumentError for getOrderBookItemsForMarket ask_limit < 1" do
    currency = "qdxusdt"
    ask_limit = "0"
    q_markets.getOrderBookItemsForMarket(currency: currency, ask_limit: ask_limit)
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "raises ArgumentError for getOrderBookItemsForMarket bids_limit < 1" do
    currency = "qdxusdt"
    bids_limit = "0"
    q_markets.getOrderBookItemsForMarket(currency: currency, bids_limit: bids_limit)
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "raises ArgumentError for getOrderBookItemsForMarket bids_limit > 200" do
    currency = "qdxusdt"
    bids_limit = "201"
    q_markets.getOrderBookItemsForMarket(currency: currency, bids_limit: bids_limit)
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "getOrderBookItemsForMarket returns kLine data for currency and trade_id" do
    currency = "qdxusdt"

    url = "#{API::BASE_URL}#{API::MARKET_PATH}/#{currency}/order_book"
    query = {
      ask_limit: "20",
      bids_limit: "20"
    }

    result = {
      data: MarketsMock::QDX_USDT_ORDERBOOK_ITEMS_FOR_MARKET
    }.to_json

    stub_request(:get, url).with(headers: test_headers, query: query).to_return(body: result)
    order_book_items_for_market_query = q_markets.getOrderBookItemsForMarket(currency: currency)

    expect(order_book_items_for_market_query["data"].nil?).to eq false

    order_book_items_for_market = order_book_items_for_market_query["data"]

    expect(order_book_items_for_market["asks"].size).to be > 0
    expect(order_book_items_for_market["bids"].size).to be > 0
  end
end

RSpec.describe "QuidaxMarkets.getDepthForAMarket" do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_markets = QuidaxMarkets.new(quidax_object)
  it "raises ArgumentError for no params" do
    q_markets.getDepthForAMarket
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "returns object with currency" do
    depth_for_market_keys = %w[timestamp asks bids]
    currency = "qdxusdt"
    url = "#{API::BASE_URL}#{API::MARKET_PATH}/#{currency}/depth"
    query = {
      limit: 10
    }

    result = { data: MarketsMock::QDX_USDT_MARKET_DEPTH }.to_json
    stub_request(:get, url).with(headers: test_headers, query: query).to_return(body: result)
    depth_for_market_query = q_markets.getDepthForAMarket(currency: currency)

    expect(depth_for_market_query["data"].nil?).to eq false

    depth_for_market = depth_for_market_query["data"]

    expect(depth_for_market.keys).to eq depth_for_market_keys
  end
end
