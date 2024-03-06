# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe QuidaxInstantOrder do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_instant_order = QuidaxInstantOrder.new(quidax_object)

  describe "get_all" do
    it "expects user_id:" do
      q_instant_order.get_all
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :user_id"
    end
    it "expects order_by: to be asc or desc" do
      user_id = "me"
      order_by = "assc"
      q_instant_order.get_all(user_id: user_id, order_by: order_by)
    rescue StandardError => e
      expect(e.message).to eq ":order_by must be one of: asc, desc"
    end
    it "expects state: to be: done, wait, cancel, confirm" do
      user_id = "me"
      state = "pend"
      q_instant_order.get_all(user_id: user_id, state: state)
    rescue StandardError => e
      expect(e.message).to eq ":state must be one of: done, wait, cancel, confirm"
    end
    it "returns an array" do
      user_id = "me"
      order_by = "asc"
      market = "usdtngn"
      state = "wait"

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::INSTANT_ORDER_PATH}"
      query = {
        market: market,
        state: state,
        order_by: order_by
      }

      stub_request(:get, url).with(headers: test_headers, query: query).to_return(body: { data: [] }.to_json)

      all_instant_orders_query = q_instant_order.get_all(user_id: user_id, **query)

      all_instant_orders = all_instant_orders_query["data"]

      expect(all_instant_orders).to be_a Array
    end
  end

  describe "by_sub_users" do
    it "expects side:, start_date:, end_date:" do
      q_instant_order.by_sub_users
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :side, :start_date, :end_date"
    end
    it "expects side: to be buy or sell" do
      params = {
        side: "selll",
        state: "pend",
        market: "btcngn",
        start_date: "",
        end_date: ""
      }
      q_instant_order.by_sub_users(**params)
    rescue StandardError => e
      expect(e.message).to eq ":side must be one of: buy, sell"
    end
    it "expects state: to be pend, wait, confirm, done, partially_done, failed, cancel" do
      side = "buy"
      market = "btcngn"
      start_date = ""
      end_date = ""
      state = "pending"
      q_instant_order.by_sub_users(side: side, market: market, start_date: start_date, end_date: end_date, state: state)
    rescue StandardError => e
      expect(e.message).to eq ":state must be one of: pend, wait, confirm, done, partially_done, failed, cancel"
    end
    it "returns array" do
      url = "#{API::BASE_URL}#{API::USER_PATH}#{API::INSTANT_ORDER_PATH}/all"
      query = {
        side: "sell",
        state: "pend",
        market: "btcngn",
        start_date: "",
        end_date: ""
      }

      stub_request(:get, url).with(headers: test_headers, query: query).to_return(body: { data: [] }.to_json)

      instant_order_by_sub_users_query = q_instant_order.by_sub_users(**query)
      instant_order_by_sub_users = instant_order_by_sub_users_query["data"]

      expect(instant_order_by_sub_users).to be_a Array
    end
  end

  describe "get_detail" do
    it "expects user_id:, instant_order_id:" do
      q_instant_order.get_detail
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :instant_order_id"
    end
    it "returns Hash" do
      user_id = "me"
      instant_order_id = "12345"
      input = { user_id: user_id, instant_order_id: instant_order_id }
      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::INSTANT_ORDER_PATH}/#{instant_order_id}"

      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: {} }.to_json)

      instant_order_detail_query = q_instant_order.get_detail(**input)
      instant_order_detail = instant_order_detail_query["data"]

      expect(instant_order_detail).to be_a Hash
    end
  end

  describe "buy_crypto_from_fiat" do
    it "expects user_id:, body:" do
      q_instant_order.buy_crypto_from_fiat
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :body"
    end
    it "expect body: to have bid, ask, volume" do
      q_instant_order.buy_crypto_from_fiat(user_id: "me", body: {})
    rescue StandardError => e
      expect(e.message).to eq "missing key(s) in :body bid, ask, volume"
    end
    it "expect bid: to be a supported currency" do
      q_instant_order.buy_crypto_from_fiat(user_id: "me", body: {
                                             bid: "usdc",
                                             ask: "btc",
                                             volume: 0.002
                                           })
    rescue StandardError => e
      expect(e.message).to eq ":bid must be one of: ngn, usdt"
    end
    it "expect ask: to be a supported currency" do
      q_instant_order.buy_crypto_from_fiat(user_id: "me", body: {
                                             bid: "usdt",
                                             ask: "meme",
                                             volume: 0.002
                                           })
    rescue StandardError => e
      expect(e.message).to eq ":ask must be one of: btc, ltc, eth, xrp, usdt, dash, usdc, busd, bnb"
    end

    it "returns hash" do
      user_id = "me"
      body = {
        bid: "ngn",
        ask: "btc",
        volume: 0.1
      }
      test_body = {
        **body,
        unit: body[:bid],
        type: "buy"
      }.to_json

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::INSTANT_ORDER_PATH}"
      stub_request(:post, url).with(headers: test_headers, body: test_body).to_return(body: { data: {} }.to_json)
      buy_crypto_from_fiat_query = q_instant_order.buy_crypto_from_fiat(user_id: user_id, body: body)

      buy_crypto_from_fiat = buy_crypto_from_fiat_query["data"]

      expect(buy_crypto_from_fiat).to be_a Hash
    end
  end

  describe "sell_crypto_to_fiat" do
    it "expects user_id:, body:" do
      q_instant_order.sell_crypto_to_fiat
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :body"
    end
    it "expect body: to have bid, ask, total" do
      q_instant_order.sell_crypto_to_fiat(user_id: "me", body: {})
    rescue StandardError => e
      expect(e.message).to eq "missing key(s) in :body bid, ask, total"
    end
    it "expect bid: to be a supported currency" do
      q_instant_order.sell_crypto_to_fiat(user_id: "me", body: {
                                            bid: "usdc",
                                            ask: "btc",
                                            total: 1000
                                          })
    rescue StandardError => e
      expect(e.message).to eq ":bid must be one of: ngn, usdt"
    end
    it "expect ask: to be a supported currency" do
      q_instant_order.sell_crypto_to_fiat(user_id: "me", body: { bid: "usdt", ask: "meme", total: 1000 })
    rescue StandardError => e
      expect(e.message).to eq ":ask must be one of: btc, ltc, eth, xrp, usdt, dash, usdc, busd, bnb"
    end

    it "returns hash" do
      user_id = "me"
      body = {
        bid: "ngn",
        ask: "btc",
        total: 100
      }
      test_body = {
        **body,
        unit: body[:bid],
        type: "sell"
      }.to_json

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::INSTANT_ORDER_PATH}"
      stub_request(:post, url).with(headers: test_headers, body: test_body).to_return(body: { data: {} }.to_json)

      sell_crypto_to_fiat_query = q_instant_order.sell_crypto_to_fiat(user_id: user_id, body: body)

      sell_crypto_to_fiat = sell_crypto_to_fiat_query["data"]

      expect(sell_crypto_to_fiat).to be_a Hash
    end
  end

  describe "confirm" do
    it "expects :user_id, :instant_order_id" do
      q_instant_order.confirm
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :instant_order_id"
    end

    it "returns hash" do
      user_id = "me"
      instant_order_id = "1234"

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::INSTANT_ORDER_PATH}/#{instant_order_id}/confirm"

      stub_request(:post, url).with(headers: test_headers).to_return(body: { data: {} }.to_json)

      confirm_instant_order_query = q_instant_order.confirm(user_id: user_id, instant_order_id: instant_order_id)
      confirm_instant_order = confirm_instant_order_query["data"]

      expect(confirm_instant_order).to be_a Hash
    end
  end

  describe "requote" do
    it "expects :user_id, :instant_order_id" do
      q_instant_order.requote
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :instant_order_id"
    end
    it "returns hash" do
      user_id = "me"
      instant_order_id = "1234"

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::INSTANT_ORDER_PATH}/#{instant_order_id}/requote"

      stub_request(:post, url).with(headers: test_headers).to_return(body: { data: {} }.to_json)

      requote_instant_order_query = q_instant_order.requote(user_id: user_id, instant_order_id: instant_order_id)
      confirm_instant_order = requote_instant_order_query["data"]

      expect(confirm_instant_order).to be_a Hash
    end
  end
end
