# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe QuidaxOrder do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_order = QuidaxOrder.new(quidax_object)

  describe "getAll" do
    it "expects user_id, market, state, order_by" do
      q_order.getAll
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :market, :state, :order_by"
    end
    it "expects market, state, order_by" do
      user_id = "me"
      q_order.getAll(user_id: user_id)
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :market, :state, :order_by"
    end
    it "expects state, order_by" do
      user_id = "me"
      market = "btcusdt"
      q_order.getAll(user_id: user_id, market: market)
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :state, :order_by"
    end
    it "expects order_by" do
      user_id = "me"
      market = "btcusdt"
      state = "pending"
      q_order.getAll(user_id: user_id, market: market, state: state)
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :order_by"
    end
    it "expects order_by to be asc or desc" do
      user_id = "me"
      market = "btcusdt"
      state = "pending"
      order_by = "DESCE"
      q_order.getAll(user_id: user_id, market: market, state: state, order_by: order_by)
    rescue StandardError => e
      expect(e.message).to eq ":order_by must be one of: asc, desc"
    end

    it "returns an array" do
      user_id = "me"
      market = "btcusdt"
      state = "pending"
      order_by = "desc"

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}"
      params = {
        market: market,
        state: state,
        order_by: order_by
      }

      stub_request(:get, url).with(headers: test_headers, query: params).to_return(body: { data: [] }.to_json)

      all_orders_query = q_order.getAll(user_id: user_id, market: market, state: state, order_by: order_by)
      all_orders = all_orders_query["data"]
      expect(all_orders).to be_a Array
    end
  end
  describe "getDetails" do
    it "expects user_id, order_id" do
      q_order.getDetails
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :order_id"
    end

    it "expects order_id" do
      user_id = "me"
      q_order.getDetails(user_id: user_id)
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :order_id"
    end

    it "returns order details hash" do
      user_id = "me"
      order_id = "0np0int"

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}/#{order_id}"

      order_hash_keys = %w[id reference market side order_type price avg_price volume origin_volume executed_volume
                           status trades_count created_at updated_at done_at trades]

      stub_request(:get, url).with(headers: test_headers).to_return(body: { data: OrderMock::ORDER_DETAILS }.to_json)

      order_details_query = q_order.getDetails(user_id: user_id, order_id: order_id)
      order_details = order_details_query["data"]
      expect(order_details).to be_a Hash
    end
  end
  describe "create" do
    it "expects user_id, data" do
      q_order.create
    rescue StandardError => e
      expect(e.message).to eq "missing keywords: :user_id, :data"
    end

    it "expects data" do
      user_id = "me"
      q_order.create(user_id: user_id)
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :data"
    end
    it "expects data to have market, side, ord_type, price volume " do
      user_id = "me"
      data = {}
      q_order.create(user_id: user_id, data: data)
    rescue StandardError => e
      expect(e.message).to eq "market, side, ord_type, price, volume are missing in :data"
    end
    it "expects data to have side, ord_type, price volume " do
      user_id = "me"
      data = { market: "btcusdt" }
      q_order.create(user_id: user_id, data: data)
    rescue StandardError => e
      expect(e.message).to eq "side, ord_type, price, volume are missing in :data"
    end
    it "expects data to have ord_type, price volume " do
      user_id = "me"
      side = "buy"
      data = { market: "btcusdt", side: side }
      q_order.create(user_id: user_id, data: data)
    rescue StandardError => e
      expect(e.message).to eq "ord_type, price, volume are missing in :data"
    end
    it "expects data to have price, volume " do
      user_id = "me"
      side = "buy"
      ord_type = "limit"
      data = { market: "btcusdt", side: side, ord_type: ord_type }
      q_order.create(user_id: user_id, data: data)
    rescue StandardError => e
      expect(e.message).to eq "price, volume are missing in :data"
    end
    it "expects data to have volume " do
      user_id = "me"
      side = "buy"
      ord_type = "limit"
      price = "61000"
      data = { market: "btcusdt", side: side, ord_type: ord_type, price: price }
      q_order.create(user_id: user_id, data: data)
    rescue StandardError => e
      expect(e.message).to eq "volume are missing in :data"
    end
    it "expects data['side'] to buy or sell " do
      user_id = "me"
      side = "selll"
      ord_type = "limit"
      price = "61000"
      volume = "0.001"
      data = { market: "btcusdt", side: side, ord_type: ord_type, price: price, volume: volume }
      q_order.create(user_id: user_id, data: data)
    rescue StandardError => e
      expect(e.message).to eq "data['side'] must be one of buy, sell"
    end
    it "returns an order hash" do
      user_id = "me"
      side = "sell"
      ord_type = "limit"
      price = "61000"
      volume = "0.001"
      data = { market: "btcusdt", "side": side, ord_type: ord_type, price: price, volume: volume }

      url = "#{API::BASE_URL}#{API::USER_PATH}/#{user_id}#{API::ORDER_PATH}"

      stub_request(:post, url).with(headers: test_headers,
                                    body: data.to_json).to_return(body: { data: OrderMock::ORDER_DETAILS }.to_json)
      new_order_query = q_order.create(user_id: user_id, data: data)
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
    it "expects order_id" do
      user_id = "me"
      q_order.cancel(user_id: user_id)
    rescue StandardError => e
      expect(e.message).to eq "missing keyword: :order_id"
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
end
