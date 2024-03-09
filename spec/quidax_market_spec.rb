# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe QuidaxMarkets do
  quidax_object = Quidax.new(test_secret_key)
  q_markets = QuidaxMarkets.new(quidax_object)

  describe "get_all" do
    it "returns Array" do
      url = "#{API::BASE_URL}#{API::MARKET_PATH}"
      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: MarketsMock::ALL_MARKETS }.to_json)

      all_markets_query = q_markets.get_all
      expect(all_markets_query["data"].nil?).to eq false

      all_markets_data = all_markets_query["data"]
      expect(all_markets_data).to be_a Array
    end
  end

  describe "get_all_tickers" do
    it "returns Hash" do
      url = "#{API::BASE_URL}#{API::MARKET_PATH}/tickers"

      stub_request(:get,
                   url).with(headers: test_headers).to_return(body: { data: MarketsMock::ALL_MARKET_TICKERS }.to_json)

      all_market_tickers_query = q_markets.get_all_tickers

      expect(all_market_tickers_query["data"].nil?).to eq false

      all_market_tickers = all_market_tickers_query["data"]
      expect(all_market_tickers).to be_a Hash
    end
  end

  describe "get_ticker" do
    it "expects :market" do
      q_markets.get_ticker
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :market"
    end
    it "returns Hash" do
      market = "qdxusdt"
      url = "#{API::BASE_URL}#{API::MARKET_PATH}/tickers/#{market}"

      stub_request(:get,
                   url).with(headers: test_headers).to_return(body: { data: MarketsMock::QDX_USDT_MARKET_TICKER }.to_json)

      market_ticker_query = q_markets.get_ticker(market: market)

      market_ticker = market_ticker_query["data"]
      expect(market_ticker).to be_a Hash
    end
  end

  describe "get_k_line" do
    it "expects :market" do
      q_markets.get_k_line
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :market"
    end
    it "query expects period, limit" do
      q_markets.get_k_line(market: "btcngn", query: {})
    rescue StandardError => e
      expect(e.message).to eq "missing key(s) in :query period, limit"
    end

    it "returns hash" do
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

      kline_for_market_query = q_markets.get_k_line(market: market, query: query)

      kline_for_market = kline_for_market_query["data"]

      expect(kline_for_market.all? { |item| item.is_a?(Float) }).to eq true
    end
  end

  describe "get_k_line_with_pending_trades" do
    it "expects :market, :trade_id" do
      q_markets.get_k_line_with_pending_trades
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :market, :trade_id"
    end

    it "query expects period, limit" do
      q_markets.get_k_line_with_pending_trades(market: "btcusdt", trade_id: "3344", query: {})
    rescue StandardError => e
      expect(e.message).to eq "missing key(s) in :query period, limit"
    end
    it "query.limit should be between 1..10_000" do
      q_markets.get_k_line_with_pending_trades(market: "btcusdt", trade_id: "3344", query: { limit: 10_001, period: 1 })
    rescue StandardError => e
      expect(e.message).to eq 'query["limit"] must be between 1..10000'
    end
    it "returns Array" do
      market = "qdxusdt"
      trade_id = "3"
      query = {
        period: 1,
        limit: 30
      }

      url = "#{API::BASE_URL}#{API::MARKET_PATH}/#{market}/k_with_pending_trades/#{trade_id}"

      result = { data: MarketsMock::QDX_USDT_K_WITH_PENDING_TRADES }.to_json

      stub_request(:get, url).with(headers: test_headers, query: query).to_return(body: result)

      k_with_pending_trades_query = q_markets.get_k_line_with_pending_trades(market: market, trade_id: trade_id)

      k_with_pending_trades = k_with_pending_trades_query["data"]

      expect(k_with_pending_trades["k"]).to be_a Array
    end
  end

  describe "get_orderbook_items" do
    it "expects :market" do
      q_markets.get_orderbook_items
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :market"
    end
    it ":query expects ask_limit, bids_limit" do
      q_markets.get_orderbook_items(market: "btcusdt", query: {})
    rescue StandardError => e
      expect(e.message).to eq "missing key(s) in :query ask_limit, bids_limit"
    end
    it "query.ask_limit should be between 1 and 200" do
      q_markets.get_orderbook_items(market: "btcusdt", query: { ask_limit: "201", bids_limit: "5" })
    rescue StandardError => e
      expect(e.message).to eq 'query["ask_limit"] must be between 1..200'
    end
    it "query.bids_limit should be between 1 and 200" do
      q_markets.get_orderbook_items(market: "btcusdt", query: { ask_limit: "20", bids_limit: "-1" })
    rescue StandardError => e
      expect(e.message).to eq 'query["bids_limit"] must be between 1..200'
    end

    it "returns asks and bids Array" do
      market = "qdxusdt"

      url = "#{API::BASE_URL}#{API::MARKET_PATH}/#{market}/order_book"
      query = {
        ask_limit: "20",
        bids_limit: "30"
      }

      result = {
        data: MarketsMock::QDX_USDT_ORDERBOOK_ITEMS_FOR_MARKET
      }.to_json

      stub_request(:get, url).with(headers: test_headers, query: query).to_return(body: result)
      order_book_items_for_market_query = q_markets.get_orderbook_items(market: market, query: query)

      order_book_items_for_market = order_book_items_for_market_query["data"]

      expect(order_book_items_for_market["asks"]).to be_a Array
      expect(order_book_items_for_market["bids"]).to be_a Array
    end
  end

  describe "get_depth_for_a_market" do
    it "expects :market" do
      q_markets.get_depth_for_a_market
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :market"
    end
    it "query expects limit" do
      q_markets.get_depth_for_a_market(market: "btcusdt", query: {})
    rescue StandardError => e
      expect(e.message).to eq "missing key(s) in :query limit"
    end
    it "returns Hash" do
      market = "qdxusdt"
      url = "#{API::BASE_URL}#{API::MARKET_PATH}/#{market}/depth"
      query = {
        limit: 23
      }

      result = { data: MarketsMock::QDX_USDT_MARKET_DEPTH }.to_json
      stub_request(:get, url).with(headers: test_headers, query: query).to_return(body: result)
      depth_for_market_query = q_markets.get_depth_for_a_market(market: market, query: query)

      depth_for_market = depth_for_market_query["data"]

      expect(depth_for_market).to be_a Hash
    end
  end
end
