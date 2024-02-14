# frozen_string_literal: true

# Object for markets
class QuidaxMarkets < QuidaxBaseObject
  def getAllMarkets
    QuidaxMarkets.getAllMarkets(q_object: @quidax)
  end

  def getAllMarketTickers
    QuidaxMarkets.getAllMarketTickers(q_object: @quidax)
  end

  def getMarketTicker(currency:)
    QuidaxMarkets.getMarketTicker(q_object: @quidax, currency: currency)
  end

  def getKlineForMarket(market:)
    QuidaxMarkets.getKlineForMarket(q_object: @quidax, market: market)
  end

  def getKlineWithPendingTrades(currency:, trade_id:)
    QuidaxMarkets.getKlineWithPendingTrades(q_object: @quidax, currency: currency, trade_id: trade_id)
  end

  def getOrderBookItemsForMarket(currency:, ask_limit:, bids_limit:)
    QuidaxMarkets.getOrderBookItemsForMarket(q_object: @quidax, currency: currency, ask_limit: ask_limit,
                                             bids_limit: bids_limit)
  end

  def self.getAllMarkets(q_object:)
    get_request(q_object, API::MARKET_PATH)
  end

  def self.getAllMarketTickers(q_object:)
    path = "#{API::MARKET_PATH}/tickers"
    get_request(q_object, path)
  end

  def self.getMarketTicker(q_object:, currency:)
    path = "#{API::MARKET_PATH}/tickers/#{currency}"
    get_request(q_object, path)
  end

  def self.getKlineForMarket(q_object:, market:)
    path = "#{API::MARKET_PATH}/#{market}/k"
    get_request(q_object, path)
  end

  def self.getKlineWithPendingTrades(q_object:, currency:, trade_id:)
    path = "#{API::MARKET_PATH}/#{currency}/k_with_pending_trades/#{trade_id}"
    get_request(q_object, path)
  end

  def self.getOrderBookItemsForMarket(q_object:, currency:, ask_limit: "20", bids_limit: "20")
    ask_limit_integer = ask_limit.to_i
    bids_limit_integer = bids_limit.to_i

    if ask_limit_integer > 200 || ask_limit_integer < 1 || bids_limit_integer > 200 || bids_limit_integer < 1
      raise ArgumentError
    end

    path = "#{API::MARKET_PATH}/#{currency}/order_book"
    params = {
      ask_limit: ask_limit,
      bids_limit: bids_limit
    }
    get_request(q_object, path, params)
  end

  def self.getDepthForAMarket(q_object:, currency:, limit:)
    path = "#{API::MARKET_PATH}/#{currency}/depth"
    params = {
      limit: limit
    }
    get_request(q_object, path, params)
  end
end
