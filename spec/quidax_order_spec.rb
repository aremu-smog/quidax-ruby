# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe QuidaxOrder do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_order = QuidaxOrder.new(quidax_object)

  describe "get_all" do
    it "expects :user_id, :query" do
      q_order.get_all
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :query"
    end

    it "expects :query to have market, state" do
      user_id = "me"
      query = {}
      q_order.get_all(user_id: user_id, query: query)
    rescue StandardError => e
      expect(e.message).to eq "missing key(s) in :query market"
    end

    it "expects query.order_by to be asc or desc" do
      user_id = "me"
      query = {
        market: "btcusdt",
        state: "pend",
        order_by: "DESCE"
      }

      q_order.get_all(user_id: user_id, query: query)
    rescue StandardError => e
      expect(e.message).to eq ':query["order_by"] must be one of: asc, desc'
    end

    it "returns an array" do
      user_id = "me"

      query = {
        market: "btcusdt",
        state: "wait",
        order_by: "asc"
      }

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}"

      stub_request(:get, url).with(headers: test_headers, query: query).to_return(body: { data: [] }.to_json)

      all_orders_query = q_order.get_all(user_id: user_id, query: query)
      all_orders = all_orders_query["data"]
      expect(all_orders).to be_a Array
    end
  end

  describe "create" do
    it "expects user_id, body" do
      q_order.create
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :body"
    end
    it "expects data to have market, side, ord_type, price volume " do
      user_id = "me"
      body = {}
      q_order.create(user_id: user_id, body: body)
    rescue StandardError => e
      expect(e.message).to eq "missing key(s) in :body market, side, ord_type, price, volume"
    end

    it "expects data['side'] to buy or sell " do
      user_id = "me"
      side = "selll"
      ord_type = "limit"
      price = "61000"
      volume = "0.001"
      body = { market: "btcusdt", side: side, ord_type: ord_type, price: price, volume: volume }
      q_order.create(user_id: user_id, body: body)
    rescue StandardError => e
      expect(e.message).to eq ':body["side"] must be one of: buy, sell'
    end
    it "returns an order hash" do
      user_id = "me"
      side = "sell"
      ord_type = "limit"
      price = "61000"
      volume = "0.001"
      body = { market: "btcusdt", "side": side, ord_type: ord_type, price: price, volume: volume }

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}"

      stub_request(:post, url).with(headers: test_headers,
                                    body: body.to_json).to_return(body: { data: OrderMock::ORDER_DETAILS }.to_json)
      new_order_query = q_order.create(user_id: user_id, body: body)
      new_order = new_order_query["data"]

      expect(new_order).to be_a Hash
    end
  end

  describe "cancel" do
    it "expects user_id, order_id" do
      q_order.cancel
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :order_id"
    end
    it "returns order Hash" do
      user_id = "me"
      order_id = "12335"
      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}/#{order_id}/cancel"

      stub_request(:post, url).with(headers: test_headers).to_return(body: { data: OrderMock::ORDER_DETAILS }.to_json)

      cancel_order_query = q_order.cancel(user_id: user_id, order_id: order_id)
      cancel_order = cancel_order_query["data"]

      expect(cancel_order).to be_a Hash
    end
  end

  describe "get_details" do
    it "expects user_id, order_id" do
      q_order.get_details
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :order_id"
    end

    it "returns Hash" do
      user_id = "me"
      order_id = "0np0int"

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}/#{order_id}"

      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: OrderMock::ORDER_DETAILS }.to_json)

      order_details_query = q_order.get_details(user_id: user_id, order_id: order_id)
      order_details = order_details_query["data"]
      expect(order_details).to be_a Hash
    end
  end
end
