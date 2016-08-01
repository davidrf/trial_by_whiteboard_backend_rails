require "constraints/authenticated_constraint"

Rails.application.routes.draw do
  api_version(
    module: "V1",
    header: {
      name: "Accept",
      value: Mime[:v1]
    },
    defaults: { format: :v1 }
  ) do
    resources :authentication_tokens, only: :create
    resources :questions, only: [:index, :show]
    resources :users, only: [:show, :create]
    constraints AuthenticatedConstraint do
      resources :answers, only: [:update, :destroy]
      resource :authentication_tokens, only: :destroy
      resources :questions, only: [:create, :update, :destroy] do
        resources :answers, only: [:create]
      end
    end
  end
end
