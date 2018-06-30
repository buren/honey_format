# frozen_string_literal: true

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
      expect(header.to_a).to eq(%i(first column1 third))
    end

    it 'can receive converter argument as symbol' do
      header = described_class.new(['first'], converter: :upcase)
      expect(header.to_a).to eq([:FIRST])
    end
  end

  describe 'empty?' do
    it 'returns false when not empty' do
      header = described_class.new(%w[first])

      expect(header.empty?).to eq(false)
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

    it 'returns the header as a CSV-string with selected columns as symbols' do
      header = described_class.new(%w[name country age])

      expect(header.to_csv(columns: %i[country age])).to eq("country,age\n")
    end

    it 'returns the header as a CSV-string with selected columns as strings' do
      header = described_class.new(%w[name country age])

      expect(header.to_csv(columns: %w[country age])).to eq("country,age\n")
    end
  end

  one_arity_block = proc { |_v| 'c' }
  two_arity_block = proc { |_v, i| "c#{i}" }
  build_converters = lambda { |block|
    [proc(&block), lambda(&block), Class.new { define_method(:call, &block) }.new]
  }

  {
    1 => build_converters.call(one_arity_block),
    2 => build_converters.call(two_arity_block)
  }.each do |arity, converters|
    converters.each do |converter|
      describe "when given #{converter.class} converter" do
        it "calls the method with #{arity} arugment(s)" do
          header = described_class.new(%w[column0 column1], converter: converter)

          expected = arity == 1 ? %i[c c] : %i[c0 c1]
          expect(header.to_a).to eq(expected)
        end
      end
    end
  end
end
