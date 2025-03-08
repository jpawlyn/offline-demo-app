Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "pwa#manifest", as: :pwa_manifest
  get "service-worker" => "pwa#service_worker", as: :pwa_service_worker
  get "offline" => "pwa#offline"

  # Defines the root path route ("/")
  root "home#home", defaults: { offline_cache: true }

  get "offline-cached" => "home#offline_cached", defaults: { offline_cache: true }
  get "warm-cached" => "home#warm_cached", defaults: { warm_cache: true }
  get "online-only-with-fallback" => "home#online_only_with_fallback"
  get "online-only" => "home#online_only", defaults: { no_fallback: true }
end
