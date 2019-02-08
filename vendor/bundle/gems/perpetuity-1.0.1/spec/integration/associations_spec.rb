require 'spec_helper'
require 'support/test_classes'

describe 'associations with other objects' do
  let(:user) { User.new('Flump') }
  let(:topic) { Topic.new('Title', user) }
  let(:user_mapper) { Perpetuity[User] }
  let(:topic_mapper) { Perpetuity[Topic] }

  before do
    user_mapper.insert user
    topic_mapper.insert topic
  end

  describe 'referenced relationships' do
    let(:creator) { topic_mapper.find(topic_mapper.id_for topic).creator }

    it 'stores a reference in the object attribute' do
      expect(creator).to be_a Perpetuity::Reference
      expect(creator.klass).to be User
      expect(creator.id).to eq user_mapper.id_for(user)
    end
  end

  it 'can retrieve a one-to-one association' do
    retrieved_topic = topic_mapper.find(topic_mapper.id_for topic)

    topic_mapper.load_association! retrieved_topic, :creator
    expect(retrieved_topic.creator.name).to eq 'Flump'
  end

  describe 'associations with many objects' do
    let(:pragprogs) { [User.new('Dave'), User.new('Andy')] }
    let(:cuke_authors) { [User.new('Matt'), User.new('Aslak')] }
    let(:pragprog_book) { Book.new("PragProg #{Time.now.to_f}", pragprogs) }
    let(:cuke_book) { Book.new("Cucumber Book #{Time.now.to_f}", cuke_authors) }
    let(:book_mapper) { Perpetuity[Book] }

    before do
      pragprogs.each { |author| Perpetuity[User].insert author }
      book_mapper.insert pragprog_book
    end

    it 'can retrieve a one-to-many association' do
      persisted_book = book_mapper.find(book_mapper.id_for pragprog_book)
      book_mapper.load_association! persisted_book, :authors

      expect(persisted_book.authors.first.name).to be == 'Dave'
      expect(persisted_book.authors.last.name).to be == 'Andy'
    end

    it 'can retrieve a many-to-many association' do
      cuke_authors.each { |author| Perpetuity[User].insert author }
      book_mapper.insert cuke_book
      book_ids = [pragprog_book, cuke_book].map { |book| book_mapper.id_for(book) }

      books = book_mapper.select { |book| book.id.in book_ids }.to_a
      book_mapper.load_association! books, :authors
      author_names = books.map(&:authors).flatten.map(&:name)
      expect(author_names).to include(*%w(Dave Andy Matt Aslak))
    end

    it 'does not try dereferencing non-reference objects' do
      article = Article.new
      foo = User.new('foo')
      bar = 'bar'
      article.author = [foo, bar]
      mapper = Perpetuity[Article]

      mapper.insert article
      retrieved = mapper.find(mapper.id_for(article))
      mapper.load_association! retrieved, :author
      expect(retrieved.author).to be == [foo, bar]
    end
  end

  describe 'embedded relationships' do
    let(:mapper) { Perpetuity[GenericObject] }
    let(:object) { GenericObject.new }

    context 'with unserializable embedded attributes' do
      let(:unserializable_object) { 1.to_c }
      let(:serialized_attrs) do
        [ Marshal.dump(unserializable_object) ]
      end

      before { object.embedded_attribute = [unserializable_object] }

      it 'serializes attributes' do
        mapper.insert object
        attr = mapper.find(mapper.id_for object).embedded_attribute
        expect(attr).to be == [unserializable_object]
      end
    end
  end
end
