# frozen_string_literal: true

require 'spec_helper'
require 'honey_format/converters/header_column_converter'

describe HoneyFormat::HeaderColumnConverter do
  # See https://bugs.ruby-lang.org/issues/10085
  affected_ruby_version = Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.4.0')
  [
    ['first_name', :first_name],
    ['first name', :first_name],
    ['first name (user)', :first_name_user],
    ['first name [user]', :first_name_user],
    ['first name {user}', :first_name_user],
    ['first (user) name', :first_user_name],
    ['first [user] name', :first_user_name],
    ['first {user} name', :first_user_name],
    ['first (user) name', :first_user_name],
    ['Billing City', :billing_city],
    ['Total Order Value (ex VAT)', :total_order_value_ex_vat],
    ['Value (ex VAT) {SEK} [SE]', :value_ex_vat_sek_se],
    ['VAT#', :'vat#'],
    ['   first_name  ', :first_name],
    ['first-name', :first_name],
    ['USeRnaMe', :username],
    ['-username__-', :username],
    ['--username', :username],
    ['u   s e R ', :u_s_e_r],
    ['model::column', :model_column],
    ['model::::column', :model_column],
    ['model/column', :model_column],
    ['model//column', :model_column],
    ['model\column', :model_column],
    [nil, :column3, 3],
    affected_ruby_version ? ['ÅÄÖ', :'ÅÄÖ'] : ['ÅÄÖ', :'åäö'],
  ].each do |data|
    input, expected, index = data

    it "converts #{input} to #{expected}" do
      result = described_class.call(input, index)
      expect(result).to eq(expected)
    end
  end

  it 'raises error if column and index is nil' do
    expect do
      described_class.call(nil, nil)
    end.to raise_error(ArgumentError)
  end

  it 'does not mutate orignal value' do
    input = 'A'
    result = described_class.call(input, 0)
    expect(result).to eq(:a)
    expect(input).to eq('A')
  end
end
