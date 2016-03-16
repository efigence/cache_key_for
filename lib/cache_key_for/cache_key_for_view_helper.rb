# Features:
# * all features of `cache_key_for` method
# * better debugging (accepts view/partial file path for visible part of cache key)

# Example (haml):

# ```haml
#     - cache cache_key_for_view(__FILE__, @service.datacenters, 'datacenters', current_company.cache_key, Time.now.utc.to_date.to_s) do
# ```

# Rails will generate cache at:

# ```
# app_name:views/en/datacenters/5bd92bd352e7726d02175752913014711f5d412e/companies/1-20150619101645935901000/2015-06-
# 26/app/views/services/datacenters.html.haml/4324f99340fd2b2bc7e26b8e9b79d8f5
# ```
module CacheKeyForViewHelper
  include CacheKeyForHelper
  def cache_key_for_view(file, scoped_collection, collection_prefix, cache_owner_cache_key = '', suffix = '')
    "#{cache_key_for(scoped_collection, collection_prefix, cache_owner_cache_key, suffix)}#{file.gsub(Rails.root.to_s, '')}"
  end
end
