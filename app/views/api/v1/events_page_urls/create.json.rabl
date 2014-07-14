child :@events_page_url do
  attributes :id, :institution_id, :url, :events_page_url_type, :created_at, :updated_at
end

node(:errors) {@events_page_url.errors.full_messages}
