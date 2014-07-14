child :@menu_item do
  attributes :id, :name, :institution_id, :category, :details_link, :small_price, :large_price, :combo_price, :dining_place_id, :dining_opportunity_id, :created_at, :updated_at
end

node(:errors) {@menu_item.errors.full_messages}
