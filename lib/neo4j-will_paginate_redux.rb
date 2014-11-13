require "neo4j-will_paginate_redux/version"
require 'will_paginate'
require 'will_paginate/collection'
require 'will_paginate/per_page'
require 'neo4j'

module Neo4j::ActiveNode::Query
  class QueryProxy

    # The module provides the common interface for the pagination on any Enumerable class.
    # By including the module, {Neo4j::WillPaginate::Pagination#paginate} method will be available.
    include ::WillPaginate::CollectionMethods

    # Paginates the {Enumerable} and returns {::WillPaginate::Collection} instance.
    #
    # @param [Hash] options a hash of options for the pagination.
    # @option options [Symbol] :page current page for the pagination (defualts to 1).
    # @option options [Symbol] :per_page numer of items per page (defaults to {::WillPaginate.per_page}).
    #                           Aliases are `:per`, `:limit`.
    # @option options [String,Array] :return an optional string or array of identifiers used earlier in the query
    #                                 requested for return.
    # @option options [String,Symbol] :order an optional QueryProxy `order` clause to sort your results
    #
    # @example Paginate on a relationship:
    #   person.friends.paginate(:page => 5, :per_page => 10)
    #
    # @example Paginate the search results:
    #   Person.all(:conditions => "name: Dmytrii*").paginate(:page => 5, :per_page => 10)
    def paginate(options={})
      @page         = (options[:page] || 1).to_i
      @per_page     = (options[:per] || options[:per_page] || options[:limit] || ::WillPaginate.per_page).to_i
      @result_order = options[:order]
      @returns      = to_return(options[:return])
      ::WillPaginate::Collection.create(page, per_page) { |pager| pager_return(pager) }
    end

    attr_reader :page, :per_page, :result_order, :returns

    private

    def pager_return(pager)
      res = ::Neo4j::Paginated.create_from(self, page, per_page, result_order)
      return_method = returns.nil? ? Proc.new { res.to_a } : Proc.new { res.pluck(*returns) }
      pager.replace return_method.call
      pager.total_entries = res.total unless pager.total_entries
    end

    def to_return(returns)
      case returns
      when Array
        returns
      when Symbol
        [returns]
      else
        nil
      end
    end
  end
end
