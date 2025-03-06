# The Rails::PwaController is not used since we need to disable CSP for the service worker
# since Google Workbox SW is imported from a CDN and `offline` action has been added
# https://github.com/rails/rails/pull/54657
class PwaController < ActionController::Base
  skip_forgery_protection
  content_security_policy false, only: :service_worker
  layout "application", only: :offline

  def manifest; end

  def service_worker; end

  def offline; end
end
