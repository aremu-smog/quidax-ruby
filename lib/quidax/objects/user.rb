require "quidax/objects/base.rb"

class QuidaxUser < QuidaxBaseObject
    def getAccountDetails(account_id)
         return QuidaxUser.getAccountDetails(@quidax, account_id)
    end
    
    def createSubAcccount(data)
        QuidaxUser.getAccountDetails(@quidax, data)
    end

    def getAllSubAccounts
        return QuidaxUser.getAllSubAccounts(@quidax)
    end


    def self.getAccountDetails(quidaxObject, account_id)
         get_request(quidaxObject, "#{API::USER_PATH}/#{account_id}")
    end

    def self.createSubAcccount(quidaxObject, data)
        post_request(quidaxObject, "#{API::USER_PATH}", data)
    end

    def self.getAllSubAccounts(quidaxObject)
        get_request(quidaxObject, API::USER_PATH)
    end

    def self.editAccount(quidaxObject, account_id, data)
        put_request(quidaxObject, "#{API::USER_PATH}/#{account_id}", data)
    end
end