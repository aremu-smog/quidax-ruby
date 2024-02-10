# frozen_string_literal: true

require "quidax/objects/base"

# Object for user related operations
class QuidaxUser < QuidaxBaseObject
  def getAccountDetails(account_id)
    QuidaxUser.getAccountDetails(@quidax, account_id)
  end

  def createSubAcccount(data)
    QuidaxUser.createSubAcccount(@quidax, data)
  end

  def getAllSubAccounts
    QuidaxUser.getAllSubAccounts(@quidax)
  end

  def editAccount(account_id, data)
    QuidaxUser.editAccount(@quidax, account_id, data)
  end

  def self.getAccountDetails(quidaxObject, account_id)
    get_request(quidaxObject, "#{API::USER_PATH}/#{account_id}")
  end

  def self.createSubAcccount(quidaxObject, data)
    post_request(quidaxObject, API::USER_PATH, data)
  end

  def self.getAllSubAccounts(quidaxObject)
    get_request(quidaxObject, API::USER_PATH)
  end

  def self.editAccount(quidaxObject, account_id, data)
    put_request(quidaxObject, "#{API::USER_PATH}/#{account_id}", data)
  end
end
