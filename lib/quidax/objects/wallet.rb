class QuidaxWallet < QuidaxBaseObject

    def getAllWallets(account_id)
        return QuidaxWallet.getAllWallets(account_id)
    end
    
    def self.getAllWallets(account_id)
        path = "#{API::USER_PATH}/#{account_id}/wallets"
        get_request(path)
    end


end