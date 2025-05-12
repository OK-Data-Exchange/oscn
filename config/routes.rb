require 'sidekiq/web'

Rails.application.routes.draw do

  # devise_for :users, :controllers => { sessions: "devise/after_magic_link_sent_sessions" }
  get 'passwordless_sent', to: 'home#passwordless_sent'

  root to: "home#index"


  get 'person', to: 'home#person'
  get 'person_detail', to: 'home#person_detail'

  # get 'login', to: "home#login", as: 'login_url'
  mount Sidekiq::Web => "/sidekiq"
end
