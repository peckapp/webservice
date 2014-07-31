child :@unique_device_identifier do
  attributes :id, :udid, :created_at, :updated_at
end

node(:errors) {@unique_device_identifier.errors.full_messages}
