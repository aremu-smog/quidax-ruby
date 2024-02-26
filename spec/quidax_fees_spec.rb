test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe QuidaxFee do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_fees = QuidaxFee.new(quidax_object)
  it "raises ArgumentError with no params" do
    q_fees.get
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError with only currency" do
    q_fees.get(currency: "xlm")
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end
  it "raises ArgumentError with only network" do
    q_fees.get(network: "bep20")
  rescue StandardError => e
    expect(e.instance_of?(ArgumentError)).to eq true
  end

  it "returns object" do
    currency = "qdx"
    network = "bep20"

    url = "#{API::BASE_URL}#{API::FEE_PATH}"
    params = {
      currency: currency,
      network: network
    }

    result = { data: FeesMock::BTC_FEE }.to_json

    stub_request(:get, url).with(headers: test_headers, query: params).to_return(body: result)

    btc_fee_query = q_fees.get(currency: currency, network: network)
    btc_fee = btc_fee_query["data"]

    expect(btc_fee.nil?).to eq false
    expect(btc_fee.keys).to eq %w[fee type]
  end
end
