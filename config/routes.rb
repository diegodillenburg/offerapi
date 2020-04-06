Rails.application.routes.draw do
  resources :offers, only: [:index, :create, :update, :destroy] do
    put :override_state, on: :member
  end
end
