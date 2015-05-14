require 'perpetuity/postgres/json_string_value'

module Perpetuity
  class Postgres
    describe JSONStringValue do
      it 'serializes into a JSON string value' do
        expect(JSONStringValue.new('Jamie').to_s).to be == '"Jamie"'
      end

      it 'converts symbols into strings' do
        expect(JSONStringValue.new(:foo).to_s).to be == '"foo"'
      end

      it 'escapes quotes' do
        expect(JSONStringValue.new('Anakin "Darth Vader" Skywalker').to_s).to be ==
          '"Anakin \\"Darth Vader\\" Skywalker"'
      end
      
      it 'escapes horizontal tabs' do
        expect(TextValue.new("Jamie:\t author").to_s).to be == "'Jamie:\\\t author'"
      end
      
      it 'escapes newlines' do
        expect(TextValue.new("Anakin\nLuke").to_s).to be == "'Anakin\\\nLuke'"
      end
      
      it 'escapes carriage returns' do
        expect(TextValue.new("Leia\rHan").to_s).to be == "'Leia\\\rHan'"
      end
    end
  end
end
