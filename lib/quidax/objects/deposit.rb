# frozen_string_literal: true

# Deposit Object
class QuidaxDeposit < QuidaxBaseObject
  def getDepositsByUser(user:, currency:, state:)
    QuidaxDeposit.getDepositsByUser(q_object: @quidax, user: user, state: state, currency: currency)
  end

  def getADeposit(user_id:, deposit_id:)
    QuidaxDeposit.getADeposit(q_object: @quidax, user_id: user_id, deposit_id: deposit_id)
  end

  def getDepositsBySubUsers
    QuidaxDeposit.getDepositsBySubUsers(q_object: @quidax)
  end

  def self.getDepositsByUser(q_object:, user:, currency:, state:)
    path = "#{API::USER_PATH}/#{user}/#{API::DEPOSIT_PATH}"

    allowed_states = %w[submitting canceled submitted rejected failed accepted checked]
    raise ArgumentError, "#{state} must be one of #{allowed_states}" unless allowed_states.include? state

    params = {
      currency: currency,
      state: state
    }

    get_request(q_object, path, params)
  end

  def self.getADeposit(q_object:, user_id:, deposit_id:)
    path = "#{API::USER_PATH}/#{user_id}#{API::DEPOSIT_PATH}/#{deposit_id}"

    get_request(q_object, path)
  end

  def self.getDepositsBySubUsers(q_object:)
    path = "#{API::USER_PATH}#{API::DEPOSIT_PATH}/all"

    get_request(q_object, path)
  end
end
