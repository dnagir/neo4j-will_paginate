require "neo4j-will_paginate/version"
require 'will_paginate/collection'
require 'neo4j'


module Neo4j
  module WillPaginate

    module Pagination
      include ::WillPaginate::CollectionMethods


      def paginate(options={})
        page      = options[:page] || 1
        per_page  = options[:per] || options[:per_page] || options[:limit] || WillPaginate.per_page
        ::WillPaginate::Collection.create(page, per_page) do |pager|
          res = ::Neo4j::Paginated.create_from(self, page, per_page)
          pager.replace res.to_a
          pager.total_entries = res.total unless pager.total_entries
        end
      end

    end

  end

end

[
  Neo4j::Traversal::Traverser,
  Neo4j::Index::LuceneQuery,
  Neo4j::HasN::Mapping,
  Neo4j::Rails::Relationships::NodesDSL,
  Neo4j::HasList::Mapping,
  Neo4j::Rails::Relationships::RelsDSL
].each do |m|
  m.send :include, Neo4j::WillPaginate::Pagination
end
