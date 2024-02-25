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

  def getKlineForMarket(market:, period: nil, limit: nil, timestamp: nil)
    QuidaxMarkets.getKlineForMarket(q_object: @quidax, market: market, timestamp: timestamp, period: period,
                                    limit: limit)
  end

  def getKlineWithPendingTrades(currency:, trade_id:, timestamp: nil, period: nil, limit: nil)
    QuidaxMarkets.getKlineWithPendingTrades(q_object: @quidax, currency: currency, trade_id: trade_id,
                                            timestamp: timestamp, period: period, limit: limit)
  end

  def getOrderBookItemsForMarket(currency:, ask_limit: nil, bids_limit: nil)
    QuidaxMarkets.getOrderBookItemsForMarket(q_object: @quidax, currency: currency, ask_limit: ask_limit,
                                             bids_limit: bids_limit)
  end

  def getDepthForAMarket(currency:, limit: nil)
    QuidaxMarkets.getDepthForAMarket(q_object: @quidax, currency: currency, limit: limit)
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

  def self.getKlineForMarket(q_object:, market:, timestamp: nil, period: nil, limit: nil)
    period ||= 1
    limit ||= 30
    allowed_periods = [1, 5, 15, 30, 60, 120, 240, 360, 720, 1440, 4320, 10_080]

    raise ArgumentError, "period should be one of #{allowed_periods}" unless allowed_periods.include?(period)
    raise ArgumentError if limit > 10_000 || limit < 1

    path = "#{API::MARKET_PATH}/#{market}/k"
    params = {
      period: period,
      limit: limit
    }

    params["timestamp"] = timestamp unless timestamp.nil?

    get_request(q_object, path, params)
  end

  def self.getKlineWithPendingTrades(q_object:, currency:, trade_id:, timestamp: nil, period: nil, limit: nil) # rubocop:disable Metrics/ParameterLists
    period ||= 1
    limit ||= 30

    allowed_periods = [1, 5, 15, 30, 60, 120, 240, 360, 720, 1440, 4320, 10_080]

    raise ArgumentError, "period should be one of #{allowed_periods}" unless allowed_periods.include?(period)
    raise ArgumentError if limit > 10_000 || limit < 1

    params = {
      period: period,
      limit: limit
    }

    params["timestamp"] = timestamp unless timestamp.nil?

    path = "#{API::MARKET_PATH}/#{currency}/k_with_pending_trades/#{trade_id}"
    get_request(q_object, path)
  end

  def self.getOrderBookItemsForMarket(q_object:, currency:, ask_limit: nil, bids_limit: nil)
    ask_limit ||= "20"
    bids_limit ||= "20"
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

  def self.getDepthForAMarket(q_object:, currency:, limit: nil)
    limit ||= 10
    path = "#{API::MARKET_PATH}/#{currency}/depth"
    params = {
      limit: limit
    }
    get_request(q_object, path, params)
  end
end
