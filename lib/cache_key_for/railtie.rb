require 'cache_key_for/cache_key_for_helper'
require 'cache_key_for/cache_key_for_view_helper'

module CacheKeyFor
  class Railtie < Rails::Railtie
    initializer 'cache_key_for.helper' do |app|
      ActionView::Base.send :include, CacheKeyForHelper
    end
    initializer 'cache_key_for_view.helper' do |app|
      ActionView::Base.send :include, CacheKeyForViewHelper
    end
  end
end
