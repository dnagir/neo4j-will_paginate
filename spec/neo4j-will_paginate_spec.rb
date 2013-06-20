require 'spec_helper'

module Specs

  class Person < ::Neo4j::Rails::Model
    property :name, :default => 'x'
    index :name
    has_n :friends
  end

  describe Neo4j::WillPaginate::Pagination do
    subject { source.paginate(:page => 2, :per_page => 3) }

    def self.should_be_paginated
      its(:size)          { should == 3 }
      its(:current_page)  { should == 2 }
      its(:per_page)      { should == 3 }
      its(:total_entries) { should == 10 }
      its(:offset)        { should == 3 }
    end

    context ::Neo4j::Core::Traversal::Traverser do
      let(:source)  { Person.all }
      before        { 10.times { Person.create } }
      should_be_paginated
    end

    context ::Neo4j::Cypher::ResultWrapper do
      let(:source)  { Neo4j._query(Person.all.query.to_s) }
      before        { 10.times { Person.create(:name => 'x') } }
      it do
        pending "does not work yet"
        should_be_paginated
      end
    end

    context ::Neo4j::Core::Traversal::CypherQuery do
      let(:source)  { Person.all.query }
      before        { 10.times { Person.create(:name => 'x') } }
      should_be_paginated
    end

    context ::Neo4j::Core::Index::LuceneQuery do
      let(:source)  { Person.all(:conditions => 'name: *') }
      before        { 10.times { Person.create(:name => 'x') } }
      should_be_paginated
    end

    describe "models & rels" do
      let(:source)  { he.friends }
      let(:he)      { Person.create }
      before        { 10.times { he.friends << Person.create }; he.save! }

      context ::Neo4j::Rails::Relationships::NodesDSL do
        should_be_paginated
      end

      context ::Neo4j::Rails::Relationships::RelsDSL do
        subject { source.paginate(:page => "2", :per => "3") } # Just a bit different set of options
        let(:source)        { he.rels(:outgoing, :friends) }
        should_be_paginated
      end
    end

    it 'should default to WillPaginate.per_page' do
      pager = Person.all.paginate
      pager.per_page.should == ::WillPaginate.per_page
    end

  end

end
