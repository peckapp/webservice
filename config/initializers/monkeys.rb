# contains monkey patches implementing various customizations


# changes the format of dates in the JSON api responses
class ActiveSupport::TimeWithZone
    def as_json(options = {})
        strftime('%s')
    end
end
