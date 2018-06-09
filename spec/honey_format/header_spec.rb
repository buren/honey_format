require 'spec_helper'

describe HoneyFormat::Header do
  describe '#initialize' do
    it 'fails with HoneyFormat::MissingHeaderError when header is nil' do
      expect do
        described_class.new(nil)
      end.to raise_error(HoneyFormat::MissingHeaderError)
    end

    it 'fails with HoneyFormat::HeaderError when header is nil' do
      expect do
        described_class.new(nil)
      end.to raise_error(HoneyFormat::HeaderError)
    end

    it 'fails with HoneyFormat::MissingHeaderError when header is empty' do
      expect do
        described_class.new([])
      end.to raise_error(HoneyFormat::MissingHeaderError)
    end

    it 'fails with HoneyFormat::HeaderError when header is empty' do
      expect do
        described_class.new([])
      end.to raise_error(HoneyFormat::HeaderError)
    end

    it 'fails with HoneyFormat::MissingHeaderColumnError when a header column is empty' do
      expect do
        described_class.new(['first', ''], converter: proc { |v| v })
      end.to raise_error(HoneyFormat::MissingHeaderColumnError)
     end

     it 'fails with HoneyFormat::HeaderError when a header column is empty' do
       expect do
         described_class.new(['first', ''], converter: proc { |v| v })
       end.to raise_error(HoneyFormat::HeaderError)
      end

    it 'generates names for missing/empty header columns' do
      header = described_class.new(['first', '', 'third'])
      expect(header.to_a).to eq([:first, :column1, :third])
    end

    context 'when given a valid argument' do
      it 'fails with HoneyFormat::UnknownHeaderColumnError when a column is found that is not in valid argument' do
        expect do
          described_class.new(%w[first third], valid: %w[first second])
        end.to raise_error(HoneyFormat::UnknownHeaderColumnError)
      end

      it 'fails with HoneyFormat::HeaderError when a column is found that is not in valid argument' do
        expect do
          described_class.new(%w[first third], valid: %w[first second])
        end.to raise_error(HoneyFormat::HeaderError)
      end

      it 'does not fail when all columns are valid' do
        cols = %w[first second]
        header = described_class.new(cols, valid: cols)
        expect(header.to_a).to eq(cols.map(&:to_sym))
      end
    end
  end

  describe 'quacks like an enumerable' do
    it 'can #map' do
      header = described_class.new(%w[first])

      expect(header.map { 'watman' }).to eq(%w[watman])
    end
  end

  it 'can return the header size' do
    header = described_class.new(%w[first second])

    expect(header.size).to eq(2)
  end

  it 'can return the header length' do
    header = described_class.new(%w[first second])

    expect(header.length).to eq(2)
  end

  describe '#original' do
    it 'can return original column names' do
      value = 'My id (string)'
      expect(described_class.new([value]).original).to eq([value])
    end
  end

  describe '#to_csv' do
    it 'returns the header as a CSV-string' do
      header = described_class.new(%w[name email])

      expect(header.to_csv).to eq("name,email\n")
    end

    it 'returns the header as a CSV-string with selected columns' do
      header = described_class.new(%w[name country age])

      expect(header.to_csv(columns: [:country, :age])).to eq("country,age\n")
    end
  end

  one_arity_block = proc { |v| 'c' }
  two_arity_block = proc { |v, i| "c#{i}" }
  build_converters = lambda { |block|
    [proc(&block), lambda(&block), Class.new { define_method(:call, &block) }.new]
  }

  {
    1 => build_converters.call(one_arity_block),
    2 => build_converters.call(two_arity_block),
  }.each do |arity, converters|
    converters.each do |converter|
      describe "when given #{converter.class} converter" do
        it "calls the method with #{arity} arugment(s)" do
          header = described_class.new(%w[column0 column1], converter: converter)

          expected = arity == 1 ? %w[c c] : %w[c0 c1]
          expect(header.to_a).to eq(expected)
        end
      end
    end
  end
end
