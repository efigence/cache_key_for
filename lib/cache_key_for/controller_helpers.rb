require 'active_support/all'
module CacheKeyFor
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :cache_key_for, :cache_key_for_view
    end

    protected

    # Features:
    # * locale
    # * pagination
    # * scoped collections
    # * deletion from and addition to collections sorted in ascending order (via embedded `count` in the key)
    # * accepts `cache_owner_cache_key` for personalized cache, eg. current_company.cache_key, current_user.cache_key etc.
    # * all params (including other than GET's query params) with proper non-utf8 data handling for key generation
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
    def cache_key_for(scoped_collection, collection_prefix, cache_owner_cache_key = '', suffix = '')
      max_updated_at = scoped_collection.to_a.map{|i| i.updated_at.to_i }.max.to_i
      count = scoped_collection.count
      ids_string = scoped_collection.to_a.map(&:id).join('-')
      request_params = request.params ? request.params.map{|k, v| [k.dup.force_encoding("UTF-8"), v.dup.force_encoding("UTF-8")] } : nil
      digest = Digest::SHA1.hexdigest("#{ids_string}-#{max_updated_at}-#{count}-#{request.path}-#{request_params}")
      "#{I18n.locale}/#{collection_prefix}/#{digest}/#{cache_owner_cache_key}/#{suffix}"
    end

    # Features:
    # * all features of `cache_key_for` method
    # * better debugging (accepts view/controller/partial file path for visible part of cache key)

    # Example (haml):

    # ```haml
    #     - cache cache_key_for_view(__FILE__, @service.datacenters, 'datacenters', current_company.cache_key, Time.now.utc.to_date.to_s) do
    # ```

    # Rails will generate cache at:

    # ```
    # app_name:views/en/datacenters/5bd92bd352e7726d02175752913014711f5d412e/companies/1-20150619101645935901000/2015-06-
    # 26/app/views/services/datacenters.html.haml/4324f99340fd2b2bc7e26b8e9b79d8f5
    # ```
    def cache_key_for_view(file, scoped_collection, collection_prefix, cache_owner_cache_key = '', suffix = '')
      "#{cache_key_for(scoped_collection, collection_prefix, cache_owner_cache_key, suffix)}#{file.gsub(Rails.root.to_s, '')}"
    end
  end
end