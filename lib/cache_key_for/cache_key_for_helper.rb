# Features:
# * ORM agnostic
# * works with arrays and Plain Old Ruby Objects (POROs) (just provide: #id, #updated_at)
# * supports locale
# * recognizes subdomains
# * deletion from and addition to collections sorted in ascending order (via embedded `count` in the key)
# * accepts `cache_owner_cache_key` for personalized cache, eg. current_company.cache_key, current_user.cache_key etc.
# * filters params with proper non-utf8 data handling for key generation
# * recognizes pagination via params (performs well for less than 100 objects per page)
# * allows to set default page and per_page or sort order or any param in `default_params` to avoid multiple different default caches
# * includes all params, not only GET's `query` params, which enables submitting of complex forms via POST,
#   which - otherwise - would have query string longer than 2048 characters (Microsoft Internet Explorer)
# * optional whitelist of first level parameters to prevent accidentally generating duplicated cache
# * strips utm_* params
# * optional suffix for:
#     * expiry tags (unlike :expires_in cache option, this offers full :file_store storage compatibility)
#     * any edge cases
# * file differentiation and file changes are handled separately by Rails' `cache` helper (md5 is added at the end of cache path)
# * one key instead of many, but also unobtrusive (example in haml):

#     ```haml
#         - cache [cache_key_for(@articles, 'articles'), @some_active_model_object, 'box-type-view'] do
#         (...)
#     ```
# * core concept of Russian Doll Caching is touching: `belongs_to :some_model, touch: true`, but if you do not use `touch`, you can still cache safely like this (example in haml):

#     ```haml
#         - cache [cache_key_for(@articles, 'articles'), @some_model_instance] do
#         (...)
#     ```

# Example (haml):

# ```haml
#     - cache cache_key_for(@service.datacenters, 'datacenters', current_company.cache_key, Time.now.utc.to_date.to_s) do
#     (...)
# ```

# Rails will generate cache at:

# ```
# app_name:views/en/datacenters/5bd92bd352e7726d02175752913014711f5d412e/companies/1-20150619101645935901000/2015-06-26/7a6f89a738006a69c1d1e0214e147bab
# ```
module CacheKeyForHelper
  def cache_key_for(scoped_collection, collection_prefix, cache_owner_cache_key = '', suffix = '', whitelist_params = [], default_params = {})
    max_updated_at = scoped_collection.to_a.map { |i| i.updated_at ? i.updated_at.utc.to_f : 0 }.max
    count = scoped_collection.count
    ids_string = scoped_collection.to_a.map(&:id).join('-')
    blacklist_params = ['utm_source', 'utm_medium', 'utm_term', 'utm_content', 'utm_campaign']
    request_params = if request.params
      if whitelist_params.empty?
        default_params.merge(request.params).reject { |k, _v| blacklist_params.include?(k.to_s) }
      else
        default_params.merge(request.params).select { |k, _v| whitelist_params.include?(k.to_s) }
      end.map { |k, v| [k.to_s.dup.force_encoding('UTF-8'), v.dup.to_s.force_encoding('UTF-8')] }
    else
      nil
    end
    digest = Digest::SHA1.hexdigest("#{ids_string}-#{max_updated_at}-#{count}-#{request.subdomains.join('.')}-#{request.path}-#{request_params}")
    # puts "Caller: #{caller.first}"
    # puts "generated cache key digest base: #{ids_string}-#{max_updated_at}-#{count}-#{request.subdomains.join('.')}-#{request.path}-#{request_params}"
    # puts "generated cache key: #{I18n.locale}/#{collection_prefix}/#{digest}/#{cache_owner_cache_key}/#{suffix}"
    "#{I18n.locale}/#{collection_prefix}/#{digest}/#{cache_owner_cache_key}/#{suffix}"
  end
end