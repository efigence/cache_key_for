module CacheKeyFor
  #
  class Application < Rails::Application
    config.secret_key_base = '816488cd0d815e01a80ca9a769e96a3409a558761ac5f5c213cde5ffc2bb6ec9fd83f507fcb92a350689f27805cc42ffaa771dbde519830adefb845c41f8d559'
    config.eager_load = false
  end
end
