Rails.application.routes.draw do
  namespace :v1 do
    resources :announcements, only: %i(create)
  end
end
