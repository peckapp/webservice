object :@user

attributes :id, :institution_id, :api_key, :created_at, :updated_at

node(:user_device_token) {@user_device_token.blank? ? nil : @user_device_token}
