

if Rails.env.production? || Rails.env.staging?
  Devise::SessionsController.ssl_required :new, :create
else
  # DO Nothing
end
