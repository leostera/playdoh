Playdoh::Application.routes.draw do
  
  scope 'api' do
    resources 'events'
  end

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  #mount RailsAdmin::Engine => '/_admin', as: 'rails_admin'
end
