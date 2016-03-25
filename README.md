# CacheKeyFor [![Build Status](https://travis-ci.org/efigence/cache_key_for.svg?branch=master)](https://travis-ci.org/efigence/cache_key_for)
Comprehensive cache key generator (complements Rails `cache` helper)

How to design a perfect cache key? This project's goal is to provide the bulletproof solution for most use cases.

## Install

cache_key_for is a Railtie. We support the versions of Ruby and Rails listed in [.travis.yml](.travis.yml).

It should be run as a gem and included in your `Gemfile`:

    gem "cache_key_for"

### \#cache_key_for

Features:
* locale
* pagination
* scoped collections
* deletion from and addition to collections sorted in ascending order (via embedded `count` in the key)
* accepts `cache_owner_cache_key` for personalized cache, eg. current_company.cache_key, current_user.cache_key etc.
* all params (including other than GET's query params) with proper non-utf8 data handling for key generation
* optional suffix for:
    * expiry tags (unlike :expires_in cache option, this offers full :file_store storage compatibility)
    * any edge cases
* file differentiation and file changes are handled separately by Rails' `cache` helper (md5 is added at the end of cache path)
* one key instead of many, but also unobtrusive (example in haml):

    ```haml
    - cache [cache_key_for(@articles, 'articles'), @some_active_model_object, 'box-type-view'] do
    (...)
    ```
* core concept of Russian Doll Caching is touching: `belongs_to :some_model, touch: true`, but if you do not use `touch`, you can still cache safely like this (example in haml):

    ```haml
    - cache [cache_key_for(@articles, 'articles'), @some_model_instance] do
    (...)
    ```

Example (haml):

```haml
- cache cache_key_for(@service.datacenters, 'datacenters', current_company.cache_key, Time.now.utc.to_date.to_s) do
(...)
```

Rails will generate cache at:

```
app_name:views/en/datacenters/5bd92bd352e7726d02175752913014711f5d412e/companies/1-20150619101645935901000/2015-06-26/7a6f89a738006a69c1d1e0214e147bab
```

### \#cache_key_for_view

Features:
* all features of `cache_key_for` method
* better debugging (accepts view/partial file path for visible part of cache key)

Example (haml):

```haml
- cache cache_key_for_view(__FILE__, @service.datacenters, 'datacenters', current_company.cache_key, Time.now.utc.to_date.to_s) do
(...)
```

Rails will generate cache at:

```
app_name:views/en/datacenters/5bd92bd352e7726d02175752913014711f5d412e/companies/1-20150619101645935901000/2015-06-
26/app/views/services/datacenters.html.haml/4324f99340fd2b2bc7e26b8e9b79d8f5
```

## Contributing

    ./bin/setup
    bundle exec rake

## Testing new versions

    rm gemfiles/*.lock
    bundle exec appraisal install

## TODO

- add coveralls