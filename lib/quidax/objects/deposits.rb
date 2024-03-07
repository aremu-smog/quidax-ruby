# frozen_string_literal: true

# Deposit Object
class QuidaxDeposits < QuidaxBaseObject
  def by_user(user_id:, query:)
    QuidaxDeposits.by_user(q_object: @quidax, user_id: user_id, query: query)
  end

  def get_a_deposit(user_id:, deposit_id:)
    QuidaxDeposits.get_a_deposit(q_object: @quidax, user_id: user_id, deposit_id: deposit_id)
  end

  def by_sub_users
    QuidaxDeposits.by_sub_users(q_object: @quidax)
  end

  def self.by_user(q_object:, user_id:, query:)
    query.stringify_keys!

    Utils.check_missing_keys(required_keys: %w[currency state], keys: query.keys, field: "query")
    allowed_states = %w[submitting canceled submitted rejected failed accepted checked]
    Utils.validate_value_in_array(array: allowed_states, value: query["state"], field: "state")

    path = "#{API::USER_PATH}/#{user_id}/#{API::DEPOSIT_PATH}"

    get_request(q_object, path, query)
  end

  def self.get_a_deposit(q_object:, user_id:, deposit_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::DEPOSIT_PATH}/#{deposit_id}"

    get_request(q_object, path)
  end

  def self.by_sub_users(q_object:)
    path = "#{API::USER_PATH}#{API::DEPOSIT_PATH}/all"

    get_request(q_object, path)
  end
end
