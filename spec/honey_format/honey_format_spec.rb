# frozen_string_literal: true

require 'spec_helper'

describe HoneyFormat do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  it 'has HoneyCSV constant' do
    expect(described_class::HoneyCSV).to eq(described_class::CSV)
  end
end
