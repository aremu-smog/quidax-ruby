# frozen_string_literal: true

# Object for withdrawal related actions
class QuidaxWithdrawal < QuidaxBaseObject
  def get_all_withdrawals_detail(user_id:, query:)
    QuidaxWithdrawal.get_all_withdrawals_detail(q_object: @quidax, user_id: user_id, query: query)
  end

  def get_detail(user_id:, withdrawal_id:)
    QuidaxWithdrawal.get_detail(q_object: @quidax, user_id: user_id, withdrawal_id: withdrawal_id)
  end

  def cancel(withdrawal_id:)
    QuidaxWithdrawal.cancel(q_object: @quidax, withdrawal_id: withdrawal_id)
  end

  def self.get_all_withdrawals_detail(q_object:, user_id:, query:)
    Utils.check_missing_keys(required_keys: %w[currency state], keys: query.keys, field: "query")
    path = "#{API::USER_PATH}/#{user_id}#{API::WITHDRAWAL_PATH}"

    get_request(q_object, path, query)
  end

  def self.get_detail(q_object:, user_id:, withdrawal_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::WITHDRAWAL_PATH}/#{withdrawal_id}"
    get_request(q_object, path)
  end

  def self.cancel(q_object:, withdrawal_id:)
    path = "#{API::USER_PATH}/me#{API::WITHDRAWAL_PATH}/#{withdrawal_id}/cancel"
    post_request(q_object, path)
  end
end
