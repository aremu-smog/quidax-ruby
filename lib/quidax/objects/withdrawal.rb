# frozen_string_literal: true

# Object for withdrawal related actions
class QuidaxWithdrawal < QuidaxBaseObject
  def getAllWithdrawalsDetail(user_id:, currency:, state:)
    QuidaxWithdrawal.getAllWithdrawalsDetail(q_object: @quidax, user_id: user_id, currency: currency, state: state)
  end

  def self.getAllWithdrawalsDetail(q_object:, user_id:, currency:, state:)
    path = "#{API::USER_PATH}/#{user_id}#{API::WITHDRAWAL_PATH}"
    params = { currency: currency, state: state }
    get_request(q_object, path, params)
  end
end
