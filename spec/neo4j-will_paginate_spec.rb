require 'spec_helper'

module Specs

  class Person < ::Neo4j::Model
    property :name, :default => 'x'
    index :name
    has_n :friends
    has_list :seen_before
  end

  describe Neo4j::WillPaginate::Pagination do
    subject { source.paginate(:page => 2, :per_page => 3) }

    context ::Neo4j::Traversal::Traverser do
      let(:source)  { Person.all }
      before        { 10.times { Person.create } }

      its(:size)          { should == 3 }
      its(:current_page)  { should == 2 }
      its(:per_page)      { should == 3 }
      its(:total_entries) { should == 10 }
      its(:offset)        { should == 3 }
    end

    context ::Neo4j::Index::LuceneQuery do
      let(:source)  { Person.all(:conditions => 'name: *') }
      before        { 10.times { Person.create(:name => 'x') } }

      its(:size)          { should == 3 }
      its(:current_page)  { should == 2 }
      its(:per_page)      { should == 3 }
      its(:total_entries) { should == 10 }
      its(:offset)        { should == 3 }
    end

    describe "models & rels" do
      let(:source)  { he.friends }
      let(:he)      { Person.create }
      before        { 10.times { he.friends << Person.create }; he.save! }

      context ::Neo4j::HasN::Mapping do
        its(:size)          { should == 3 }
        its(:current_page)  { should == 2 }
        its(:per_page)      { should == 3 }
        its(:total_entries) { should == 10 }
        its(:offset)        { should == 3 }
      end

      context ::Neo4j::Rails::Relationships::NodesDSL do
        its(:size)          { should == 3 }
        its(:current_page)  { should == 2 }
        its(:per_page)      { should == 3 }
        its(:total_entries) { should == 10 }
        its(:offset)        { should == 3 }
      end

      context ::Neo4j::Rails::Relationships::RelsDSL do
        let(:source)        { he.rels(:friends, :outgoing) }
        its(:size)          { should == 3 }
        its(:current_page)  { should == 2 }
        its(:per_page)      { should == 3 }
        its(:total_entries) { should == 10 }
        its(:offset)        { should == 3 }
      end
    end

    context ::Neo4j::HasList::Mapping do
      let(:he)      { Person.create }
      let(:source)  { he.seen_before }
      before do
        Neo4j::Transaction.run do
          10.times { he.seen_before << Person.create }
          he.save!
        end
      end

      its(:size)          { should == 3 }
      its(:current_page)  { should == 2 }
      its(:per_page)      { should == 3 }
      its(:total_entries) { should == 10 }
      its(:offset)        { should == 3 }
    end

  end

end
