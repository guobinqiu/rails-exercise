module Cacheable
  extend ActiveSupport::Concern
  included do
    def cache_write(record)
      #Rails.cache.write [record.class.to_s.underscore, record.id].join('_'), record
      $redis.set [record.class.to_s.underscore, record.id].join('_'), record.to_json
    end

    def cache_delete(record)
      #Rails.cache.delete [record.class.to_s.underscore, record.id].join('_')
      $redis.del [record.class.to_s.underscore, record.id].join('_')
    end

    def self.cache_read_multi(record_ids)
      #Rails.cache.read_multi(*record_ids).values
      $redis.mget(*record_ids).map{|json_string| new(JSON.parse(json_string))}
    end


  end
end