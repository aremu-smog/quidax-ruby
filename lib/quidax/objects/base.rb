class QuidaxBaseObject

    attr_reader :quidax

    def initialize(quidaxObject)
        raise ArgumentError.new("Quidax object cannot be nil!") unless quidaxObject != nil
        @quidax = quidaxObject
    end

end