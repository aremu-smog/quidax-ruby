# frozen_string_literal: true

test_secret_key = ENV["TEST_SECRET_KEY"]
test_headers = { "Authorization": "Bearer #{test_secret_key}" }

RSpec.describe QuidaxFee do
  quidax_object = Quidax::Quidax.new(test_secret_key)
  q_fees = QuidaxFee.new(quidax_object)
  it "expects :query" do
    q_fees.get
  rescue StandardError => e
    expect(e.message).to eq "missing keyword: :query"
  end

  it "returns Hash" do
    url = "#{API::BASE_URL}#{API::FEE_PATH}"
    query = {
      currency: "btc",
      network: "bep20"
    }

    result = { data: FeesMock::BTC_FEE }.to_json

    stub_request(:get, url).with(headers: test_headers, query: query).to_return(body: result)

    btc_fee_query = q_fees.get(query: query)
    btc_fee = btc_fee_query["data"]

    expect(btc_fee.nil?).to eq false
    expect(btc_fee.keys).to eq %w[fee type]
  end
end
