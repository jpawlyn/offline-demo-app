Rails.application.configure do
  # for Rails 8 we need to ensure routes are already loaded
  # see https://github.com/rails/rails/pull/52012
  Rails.application.reload_routes!

  def select_routes_for(tag)
    Rails.application.routes.routes.select { |route| route.defaults[tag] }.map(&:name).map do |route_name|
      Rails.application.routes.url_helpers.route_for(route_name, only_path: true)
    end
  end

  config.service_worker = ActiveSupport::OrderedOptions.new
  config.service_worker.offline_cached_paths = select_routes_for(:sw_offline_cache)
  config.service_worker.warm_cached_paths = select_routes_for(:sw_warm_cache)
  config.service_worker.no_fallback_paths = select_routes_for(:sw_no_fallback)
end
