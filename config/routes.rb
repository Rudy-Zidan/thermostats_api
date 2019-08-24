Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'

  resources :reading, only: :create do
    collection do
      get '/:tracking_number', action: :show_by_tracking_number
    end
  end

  resources :stats, only: :index
end
