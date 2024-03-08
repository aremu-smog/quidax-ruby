# frozen_string_literal: true

# Object for user related operations
class QuidaxUser < QuidaxBaseObject
  def get_account_details(user_id:)
    QuidaxUser.get_account_details(q_object: @quidax, user_id: user_id)
  end

  def create_sub_account(body:)
    QuidaxUser.create_sub_account(q_object: @quidax, body: body)
  end

  def get_all_sub_accounts
    QuidaxUser.get_all_sub_accounts(q_object: @quidax)
  end

  def edit_account(user_id:, body:)
    QuidaxUser.edit_account(q_object: @quidax, user_id: user_id, body: body)
  end

  def self.get_account_details(q_object:, user_id:)
    path = "#{API::USER_PATH}/#{user_id}"
    get_request(q_object, path)
  end

  def self.create_sub_account(q_object:, body:)
    body.stringify_keys!
    Utils.check_missing_keys(required_keys: %w[email first_name last_name phone_number], keys: body.keys,
                             field: "body")
    post_request(q_object, API::USER_PATH, body)
  end

  def self.get_all_sub_accounts(q_object:)
    get_request(q_object, API::USER_PATH)
  end

  def self.edit_account(q_object:, user_id:, body:)
    path = "#{API::USER_PATH}/#{user_id}"
    put_request(q_object, path, body)
  end
end
