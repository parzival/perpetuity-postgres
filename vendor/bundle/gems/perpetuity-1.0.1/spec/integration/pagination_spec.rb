require 'spec_helper'
require 'support/test_classes'

describe 'pagination' do
  it 'specifies the page we want' do
    expect(Perpetuity[Article].all).to respond_to :page
  end

  it 'specify the quantity per page' do
    expect(Perpetuity[Article].all).to respond_to :per_page
  end

  it 'returns an empty set when there is no data for that page' do
    mapper = Perpetuity[Article]
    mapper.delete_all
    data = mapper.all.page(2)
    expect(data).to be_empty
  end

  it 'specifies per-page quantity' do
    Perpetuity[Article].delete_all
    5.times { |i| Perpetuity[Article].insert Article.new i }
    data = Perpetuity[Article].all.page(3).per_page(2).to_a
    expect(data.size).to be 1
  end
end

