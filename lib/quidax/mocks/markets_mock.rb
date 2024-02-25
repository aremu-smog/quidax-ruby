# frozen_string_literal: true

module MarketsMock
  ALL_MARKETS = [
    {
      id: "1",
      name: "qdxusdt",
      base_unit: "qdx",
      quote_unit: "usdt",
      filters: {}
    }
  ].freeze

  QDX_USDT_ORDERBOOK_ITEMS_FOR_MARKET = {
    asks: [{}],
    bids: [{}]
  }.freeze

  QDX_USDT_MARKET_KLINE = [0.0005, 0.0049, 0.00051, 0.0005].freeze
  QDX_USDT_K_WITH_PENDING_TRADES = {
    k: QDX_USDT_MARKET_KLINE,
    trades: [
      { tid: 1, type: "buy", date: 2002, price: 0.0005, base_volume: 2000, quote_volume: 2001 }
    ]
  }.freeze

  QDX_USDT_MARKET_TICKER = {
    at: 1,
    ticker: {
      buy: "0.00055",
      sell: "0.00054",
      low: "0.00052",
      high: "0.00057",
      open: "0.00034",
      last: "0.00053",
      vol: "20000"
    },
    market: "qdxusdt"
  }.freeze

  ALL_MARKET_TICKERS =
    {
      "qdxusdt": QDX_USDT_MARKET_TICKER
    }.freeze

  QDX_USDT_MARKET_DEPTH = {
    timestamp: 120_290_909,
    asks: ["0.0005", "0.00049", "0.00051"],
    bids: ["0.00041", "0.00045", "0.00055"]
  }.freeze
end
