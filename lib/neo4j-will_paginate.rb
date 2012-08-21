require "neo4j-will_paginate/version"
require 'will_paginate/collection'
require 'neo4j'


module Neo4j
  module WillPaginate

    # The module provides the common interface for the pagination on any Enumerable class.
    # By including the module, {Neo4j::WillPaginate::Pagination#paginate} method will be available.
    module Pagination
      include ::WillPaginate::CollectionMethods


      # Paginates the {Enumerable} and returns {::WillPaginate::Collection} instance.
      #
      # @param [Hash] options a hash of options for the pagination.
      # @option options [Symbol] :page current page for the pagination (defualts to 1).
      # @option options [Symbol] :per_page numer of items per page (defaults to {::WillPaginate.per_page}).
      #                           Aliases are `:per`, `:limit`.
      #
      # @example Paginate on a relationship:
      #   person.friends.paginate(:page => 5, :per_page => 10)
      #
      # @example Paginate the search results:
      #   Person.all(:conditions => "name: Dmytrii*").paginate(:page => 5, :per_page => 10)
      def paginate(options={})
        page      = (options[:page] || 1).to_i
        per_page  = (options[:per] || options[:per_page] || options[:limit] || WillPaginate.per_page).to_i
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
  Neo4j::Core::Traversal::Traverser,
  Neo4j::Core::Index::LuceneQuery,
  Neo4j::Core::Cypher::ResultWrapper,
  Neo4j::Core::Traversal::CypherQuery,
  Neo4j::Wrapper::HasN::Nodes,
  Neo4j::Rails::Relationships::NodesDSL,
  Neo4j::Rails::Relationships::RelsDSL
].each do |m|
  m.send :include, Neo4j::WillPaginate::Pagination
end
