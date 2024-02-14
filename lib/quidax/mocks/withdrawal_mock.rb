# frozen_string_literal: true

module WithdrawalMock
  ALL_BTC_WITHDRAWAL_DETAILS = [].freeze

  WITHDRAWAL = {
    id: "1234",
    reference: "ksjdlkssjld",
    type: "",
    currency: "usdt",
    amount: "2000",
    fee: "2",
    total: "2002",
    txid: "jslkdjlsj",
    transaction_note: "stay alive",
    narration: "staying alive funds",
    status: "pend",
    reason: "nil",
    created_at: "",
    done_at: "",
    recipient: {},
    wallet: {},
    user: {}
  }.freeze

  CANCELLED_WITHDRAWAL = {}
end
