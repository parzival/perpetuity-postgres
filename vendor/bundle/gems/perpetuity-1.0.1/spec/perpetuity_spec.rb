require 'spec_helper'
require 'support/test_classes'

describe Perpetuity do
  describe 'mapper generation' do
    it 'generates mappers' do
      Perpetuity.generate_mapper_for Object
      expect(Perpetuity[Object]).to be_a Perpetuity::Mapper
    end

    it 'provides a DSL within the generated mapper' do
      Perpetuity.generate_mapper_for Object do
        id(Integer) { object_id + 1 }
        attribute :object_id
      end

      mapper = Perpetuity[Object]
      object = Object.new
      mapper.insert object
      expect(mapper.id_for(object)).to be == object.object_id + 1
      expect(mapper.attributes).to include :object_id
    end
  end

  describe 'methods on mappers' do
    let(:published)            { Article.new('Published', 'I love cats', nil, Time.now - 30) }
    let(:draft)                { Article.new('Draft', 'I do not like moose', nil, nil) }
    let(:not_yet_published)    { Article.new('Tomorrow', 'Dogs', nil, Time.now + 30) }
    let(:mapper)               { Perpetuity[Article] }

    # Counting on late-bound memoization for this.
    let(:published_id)         { mapper.id_for(published) }
    let(:draft_id)             { mapper.id_for(draft) }
    let(:not_yet_published_id) { mapper.id_for(not_yet_published) }

    before do
      mapper.insert published
      mapper.insert draft
      mapper.insert not_yet_published
    end

    it 'allows methods to act as scopes' do
      published_ids = mapper.published.to_a.map { |article| mapper.id_for(article) }
      expect(published_ids).to include published_id
      expect(published_ids).not_to include draft_id, not_yet_published_id

      unpublished_ids = mapper.unpublished.to_a.map { |article| mapper.id_for(article) }
      expect(unpublished_ids).not_to include published_id
      expect(unpublished_ids).to include draft_id, not_yet_published_id
    end
  end

  describe 'adapter registration' do
    before do
      class ExampleAdapter; end
    end

    it 'registers an adapter' do
      Perpetuity.register_adapter :example => ExampleAdapter
      expect(Perpetuity::Configuration.adapters[:example]).to be == ExampleAdapter
    end

    it 'can re-register an adapter' do
      Perpetuity.register_adapter :example => ExampleAdapter
      Perpetuity.register_adapter :example => ExampleAdapter
      expect(Perpetuity::Configuration.adapters[:example]).to be == ExampleAdapter
    end

    it 'cannot re-register an adapter with a different class than originally registered' do
      Perpetuity.register_adapter :example => ExampleAdapter
      expect { Perpetuity.register_adapter :example => TrueClass }.to raise_exception
      expect(Perpetuity::Configuration.adapters[:example]).to be == ExampleAdapter
    end
  end

end
