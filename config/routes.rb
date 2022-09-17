Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "podcasts#index"

  resources :profiles

  resources :podcasts do
    resources :episodes
  end

  direct :arena do
    "https://arena.athas.org"
  end

  direct :bwoa do
    "https://athas.org"
  end
end
