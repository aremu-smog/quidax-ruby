# frozen_string_literal: true

# Object for markets
class QuidaxMarkets < QuidaxBaseObject
  def get_all
    QuidaxMarkets.get_all(q_object: @quidax)
  end

  def get_all_tickers
    QuidaxMarkets.get_all_tickers(q_object: @quidax)
  end

  def get_ticker(market:)
    QuidaxMarkets.get_ticker(q_object: @quidax, market: market)
  end

  def get_k_line(market:, query: nil)
    QuidaxMarkets.get_k_line(q_object: @quidax, market: market, query: query)
  end

  def get_k_line_with_pending_trades(market:, trade_id:, query: nil)
    QuidaxMarkets.get_k_line_with_pending_trades(q_object: @quidax, market: market, trade_id: trade_id,
                                                 query: query)
  end

  def get_orderbook_items(market:, query: nil)
    QuidaxMarkets.get_orderbook_items(q_object: @quidax, market: market, query: query)
  end

  def get_depth_for_a_market(market:, query: nil)
    QuidaxMarkets.get_depth_for_a_market(q_object: @quidax, market: market, query: query)
  end

  def self.get_all(q_object:)
    get_request(q_object, API::MARKET_PATH)
  end

  def self.get_all_tickers(q_object:)
    path = "#{API::MARKET_PATH}/tickers"
    get_request(q_object, path)
  end

  def self.get_ticker(q_object:, market:)
    path = "#{API::MARKET_PATH}/tickers/#{market}"
    get_request(q_object, path)
  end

  def self.get_k_line(q_object:, market:, query: nil)
    query ||= {
      period: 1,
      limit: 30
    }

    query.stringify_keys!

    Utils.check_missing_keys(required_keys: %w[period limit], keys: query.keys, field: "query")
    allowed_periods = [1, 5, 15, 30, 60, 120, 240, 360, 720, 1440, 4320, 10_080]
    Utils.validate_value_in_array(array: allowed_periods, value: query["period"], field: "period")

    raise ArgumentError, "limit must be in range 1..10_00" unless (1..10_000).include?(query["limit"])

    path = "#{API::MARKET_PATH}/#{market}/k"

    get_request(q_object, path, query)
  end

  def self.get_k_line_with_pending_trades(q_object:, market:, trade_id:, query: nil)
    query ||= {
      period: 1,
      limit: 30
    }
    query.stringify_keys!

    Utils.check_missing_keys(required_keys: %w[period limit], keys: query.keys, field: "query")
    allowed_periods = [1, 5, 15, 30, 60, 120, 240, 360, 720, 1440, 4320, 10_080]

    Utils.validate_value_in_array(array: allowed_periods, value: query["period"], field: "period")

    Utils.validate_value_in_range(range: 1..10_000, value: query["limit"], field: 'query["limit"]')

    path = "#{API::MARKET_PATH}/#{market}/k_with_pending_trades/#{trade_id}"

    get_request(q_object, path, query)
  end

  def self.get_orderbook_items(q_object:, market:, query: nil)
    query ||= {
      ask_limit: "20",
      bids_limit: "20"
    }

    query.stringify_keys!

    Utils.check_missing_keys(required_keys: %w[ask_limit bids_limit], keys: query.keys, field: "query")

    Utils.validate_value_in_range(range: 1..200, value: query["ask_limit"], field: 'query["ask_limit"]')
    Utils.validate_value_in_range(range: 1..200, value: query["bids_limit"], field: 'query["bids_limit"]')

    path = "#{API::MARKET_PATH}/#{market}/order_book"

    get_request(q_object, path, query)
  end

  def self.get_depth_for_a_market(q_object:, market:, query: nil)
    query ||= {
      limit: 10
    }
    query.stringify_keys!
    Utils.check_missing_keys(required_keys: %w[limit], keys: query.keys, field: "query")
    Utils.validate_value_in_range(range: 1..10_000, value: query["limit"], field: 'query["limit"]')
    path = "#{API::MARKET_PATH}/#{market}/depth"

    get_request(q_object, path, query)
  end
end
