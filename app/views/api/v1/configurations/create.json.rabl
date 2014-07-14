child :@configuration do
  attributes :id, :mascot, :config_file_name, :created_at, :updated_at
end

node(:errors) {@configuration.errors.full_messages}
