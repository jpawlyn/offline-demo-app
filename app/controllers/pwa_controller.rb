require "rails/application_controller"

# see https://alicia-paz.medium.com/make-your-rails-app-work-offline-part-2-caching-assets-and-adding-an-offline-fallback-334729ade904
# and https://github.com/rails/rails/pull/54657
class PwaController < Rails::ApplicationController
  skip_forgery_protection
  content_security_policy false, only: :service_worker

  def manifest; end

  def service_worker; end
end
