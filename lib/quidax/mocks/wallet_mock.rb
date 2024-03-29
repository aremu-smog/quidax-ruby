# frozen_string_literal: true

module WalletMock
  ALL_WALLETS = [
    {
      id: "ppsoudo",
      currency: "btc",
      balance: "0.0001",
      locked: "0",
      staked: "0",
      user: {},
      converted_balance: "55",
      reference_currency: "usdt",
      is_crypto: true,
      created_at: "",
      updated_at: ""
    },
    {
      id: "ppsoudo",
      currency: "usdt",
      balance: "500",
      locked: "0",
      staked: "0",
      user: {},
      converted_balance: "750000",
      reference_currency: "ngn",
      is_crypto: false,
      created_at: "",
      updated_at: ""
    }
  ].freeze

  ALL_BTC_PAYMENT_ADDRESS = [
    {
      id: "34",
      reference: "sjlkjldk",
      currency: "btc",
      address: "9302983093",
      destination_tag: "Quser",
      total_payments: "0.1234",
      created_at: "",
      updated_at: ""
    },
    {
      id: "35",
      reference: "ssjlkdljkjldk",
      currency: "btc",
      address: "93043303093",
      destination_tag: "Quser",
      total_payments: "0.2034",
      created_at: "",
      updated_at: ""
    }
  ].freeze

  NEW_PAYMENT_ADDRESS = {
    id: "36",
    reference: "670",
    currency: "btc",
    address: "9302983093",
    destination_tag: "Quser",
    total_payments: "0.1534",
    created_at: "",
    updated_at: ""
  }.freeze

  PAYMENT_ADDRESS = {
    id: "34",
    reference: "sjlkjldk",
    currency: "btc",
    address: "9302983093",
    destination_tag: "Quser",
    total_payments: "0.1234",
    created_at: "",
    updated_at: ""
  }.freeze

  WALLET = {
    id: "ppsoudo",
    currency: "btc",
    balance: "0.0001",
    deposit_address: "sljdlkjsdld",
    destination_tag: "skjd",
    locked: "0",
    staked: "0",
    user: {},
    converted_balance: "55",
    reference_currency: "usdt",
    is_crypto: true,
    created_at: "",
    updated_at: ""
  }.freeze

  VALID_ADDRESS = {
    currency: "btc",
    address: "1Lbcfr7sAHTD9CgdQo3HTMTkV8LK4ZnX71",
    valid: false
  }.freeze
end
