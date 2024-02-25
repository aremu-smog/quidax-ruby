# frozen_string_literal: true

# Object for withdrawal related actions
class QuidaxWithdrawal < QuidaxBaseObject
  def getAllWithdrawalsDetail(user_id:, currency:, state:)
    QuidaxWithdrawal.getAllWithdrawalsDetail(q_object: @quidax, user_id: user_id, currency: currency, state: state)
  end

  def getWithdrawalDetail(user_id:, withdrawal_id:)
    QuidaxWithdrawal.getWithdrawalDetail(q_object: @quidax, user_id: user_id, withdrawal_id: withdrawal_id)
  end

  def cancelWithdrawal(withdrawal_id:)
    QuidaxWithdrawal.cancelWithdrawal(q_object: @quidax, withdrawal_id: withdrawal_id)
  end

  def self.getAllWithdrawalsDetail(q_object:, user_id:, currency:, state:)
    path = "#{API::USER_PATH}/#{user_id}#{API::WITHDRAWAL_PATH}"
    params = { currency: currency, state: state }
    get_request(q_object, path, params)
  end

  def self.getWithdrawalDetail(q_object:, user_id:, withdrawal_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::WITHDRAWAL_PATH}/#{withdrawal_id}"
    get_request(q_object, path)
  end

  def self.cancelWithdrawal(q_object:, withdrawal_id:)
    path = "#{API::USER_PATH}/me#{API::WITHDRAWAL_PATH}/#{withdrawal_id}/cancel"
    post_request(q_object, path)
  end
end