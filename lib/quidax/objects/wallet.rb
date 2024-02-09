class QuidaxWallet < QuidaxBaseObject

    def getAllWallets(account_id)
        return QuidaxWallet.getAllWallets(@quidax,account_id)
    end

    def getWallet(account_id, currency)
        return QuidaxWallet.getWallet(@quidax, account_id, currency)
    end
    
    def self.getAllWallets(qObject, account_id)
        path = "#{API::USER_PATH}/#{account_id}/wallets"
        get_request(qObject, path)
    end

    def self.getWallet(qObject, account_id, currency)
        path ="#{API::USER_PATH}/#{account_id}/"
        get_request(qObject, path)
    end


end