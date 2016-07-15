module ArticleSearchable
  extend ActiveSupport::Concern
  included do
    #https://github.com/elastic/elasticsearch-rails/blob/master/elasticsearch-model/README.md
    include Elasticsearch::Model
    #include Elasticsearch::Model::Callbacks

    #https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html
    def self.search(query)
      #__elasticsearch__.search(query)
      if query.blank?
        __elasticsearch__.search({
                                     query: {
                                         filtered: {
                                             query: {
                                                 match_all: {}
                                             },
                                             filter: {
                                                 term: { state: 1 }
                                             }
                                         }
                                     }
                                 })
      else
        __elasticsearch__.search({
                                     query: {
                                         #filtered: {
                                         #    query: {
                                         #        multi_match: {
                                         #            query: query,
                                         #            fields: [:title, :text]
                                         #        }
                                         #    },
                                         #    filter: {
                                         #        term: { state: 1 }
                                         #    }
                                         #}
                                         bool: {
                                             should: [
                                                 {
                                                     match: {
                                                         title: {
                                                             query: query,
                                                             operator: 'and'
                                                         }
                                                     }
                                                 },
                                                 {
                                                     match: {
                                                         text: {
                                                             query: query,
                                                             operator: 'or'
                                                         }
                                                     }
                                                 }
                                             ],
                                             minimum_should_match: 1,
                                             filter: {
                                                 term: { state: 1 }
                                             }
                                         }
                                     }
                                 })
      end
    end


    #设置索引文件本身的索引规则
    settings index: { number_of_shards: 10, number_of_replicas: 0 } do
      #分别设置每个字段的索引规则
      mappings dynamic: 'false' do
        indexes :title, analyzer: 'snowball', boost: 10
        indexes :text, analyzer: 'snowball'
        indexes :state, index: :not_analyzed
        #...
      end
    end

    #仅把指定字段存入索引文件
    def as_indexed_json(options={})
      as_json(only: [:id, :title, :text, :state])
    end
  end
end


#手动创建索引
#Article.import force: true
#rake environment elasticsearch:import:model CLASS='Article' force=true
#https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-rails