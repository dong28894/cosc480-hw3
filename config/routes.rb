Rails.application.routes.draw do
    root to: 'products#index'
    resources :products
    #get '/products', to: 'products#index'
    #get '/products/:id', to: 'products#show'
end
