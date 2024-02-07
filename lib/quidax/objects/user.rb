require "quidax/objects/base.rb"

class QuidaxUser < QuidaxBaseObject
    def create
        return QuidaxUser.create(@quidax)
    end

    # def self.create(quidaxObject)
    #     puts quidaxObject
    # end
end