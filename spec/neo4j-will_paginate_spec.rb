require 'spec_helper'
require 'rspec/its'

describe 'pagination' do
  class Lesson; end

  class Person
    include Neo4j::ActiveNode
    property :name, :default => 'x'
    has_many :both, :friends, model_class: 'Person'
    has_many :out, :lessons
  end

  class Lesson
    include Neo4j::ActiveNode
    property :subject
    has_many :in, :people, model_class: Person, origin: :lessons
  end

  describe 'will_paginate' do
    before(:all) do
      Person.destroy_all
     10.times { Person.create(name: 'x') }
   end

    subject { source.paginate(:page => 2, :per_page => 3) }

    def self.should_be_paginated
      its(:size)          { is_expected.to eq 3 }
      its(:current_page)  { is_expected.to eq 2 }
      its(:per_page)      { is_expected.to eq 3 }
      its(:total_entries) { is_expected.to eq 10 }
      its(:offset)        { is_expected.to eq 3 }
    end

    describe 'called on QueryProxy chain' do
      let(:source)  { Person.where(name: 'x') }
      should_be_paginated
    end

    describe 'specifying return' do
      context 'with a symbol' do
        let(:subject) { source.paginate(page: 2, per_page: 3, return: :p) }
        let(:source)  { Person.as(:p).where(name: 'x') }
        should_be_paginated
      end

      context 'with an array' do
        let(:source)  { Person.lessons(:l, :r) }
        let(:subject) { source.paginate(page: 2, per_page: 3, return: [:l, :r]) }
        before do
          Lesson.create
          Person.each { |p| p.lessons << Lesson.first}
        end

        it 'should contain arrays of both lessons and rels' do
          expect(subject.first).to be_an(Array)
          expect(subject.first[0]).to be_a(Lesson)
          expect(subject.first[1]).to be_a(Neo4j::Server::CypherRelationship)
        end
      end
    end

    it 'should default to WillPaginate.per_page' do
      pager = Person.where.paginate
      expect(pager.per_page).to eq ::WillPaginate.per_page
    end
  end
end
