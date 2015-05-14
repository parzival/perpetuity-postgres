require 'perpetuity/postgres/text_value'

module Perpetuity
  class Postgres
    describe TextValue do
      it 'serializes into a Postgres-compatible string' do
        expect(TextValue.new('Jamie').to_s).to be == "'Jamie'"
      end

      it 'escapes single quotes' do
        expect(TextValue.new("Jamie's house").to_s).to be == "'Jamie''s house'"
      end
      
      it 'escapes horizontal tabs' do
        expect(TextValue.new("Jamie:\t author").to_s).to be == "'Jamie:\\\t author'"
      end
      
      it 'escapes newlines' do
        expect(TextValue.new("Jamie\nMichael").to_s).to be == "'Jamie\\\nMichael'"
      end
      
      it 'escapes carriage returns' do
        expect(TextValue.new("Jamie\rMichael").to_s).to be == "'Jamie\\\rMichael'"
      end
      
    end
  end
end
