# frozen_string_literal: true

Rails.application.routes.draw do
  get 'stocks' => 'stocks#show'
  get 'up' => 'rails/health#show', as: :rails_health_check
end
