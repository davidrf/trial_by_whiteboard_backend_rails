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
    resources :users, only: :create
    constraints AuthenticatedConstraint do
      resources :questions, only: :create
    end
  end
end
