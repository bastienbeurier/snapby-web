class ActiveSupport::TimeWithZone
    def as_json(options = {})
        if ActiveSupport::JSON::Encoding.use_standard_json_time_format
			xmlschema
        else
          %(#{time.strftime("%Y/%m/%d %H:%M:%S")} #{formatted_offset(false)})
        end
    end
end