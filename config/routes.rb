Playdoh::Application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  get "welcome/index"
  root "welcome#index"
end
