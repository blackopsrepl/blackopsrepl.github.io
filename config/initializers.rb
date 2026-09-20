Bridgetown.configure do |config|
  url "https://www.vdistefano.studio"
  template_engine "erb"
  permalink "pretty"
  timezone "UTC"

  config.defaults << {
    scope: { path: "" },
    values: { layout: "default" },
  }

  %w[portfolio demos blog].each do |section|
    config.defaults << {
      scope: { path: section },
      values: { layout: "article" },
    }
  end
end
