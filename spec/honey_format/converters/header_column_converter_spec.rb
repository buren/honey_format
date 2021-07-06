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
    ['VAT1#', :vat1],
    ['   first_name  ', :first_name],
    ['   first    name    ', :first_name],
    ["   first  \t  name    ", :first_name],
    ["﻿candidate_id", :candidate_id], # this line leads with: Unicode Character 'ZERO WIDTH NO-BREAK SPACE' (U+FEFF)
    ['FirstName', :firstname],
    ['first-name', :first_name],
    ['first.name', :first_name],
    ['first..name', :first_name],
    ['first.and.last.name', :first_and_last_name],
    ['first.,name', :first_name],
    ['USeRnaMe', :username],
    ['-username__-', :username],
    ['--username', :username],
    ['u   s e R ', :u_s_e_r],
    ['model::column', :model_column],
    ['model::::column', :model_column],
    ['model/column', :model_column],
    ['model//column', :model_column],
    ['model\column', :model_column],
    ['"model\column"', :model_column],
    ['model|column', :model_column],
    ['model%|*&$^#€£column', :model_column],
    ['Member.Kontonr', :member_kontonr],
    ['Member.Detaljkoder område 3', :'member_detaljkoder_område_3'],
    ['Member.RFM-värde', :'member_rfm_värde'],
    ['@me', :at_me],
    ['😎', :"😎"],
    ['😎_time', :"😎_time"],
    ['😎_(of the)_time', :"😎_of_the_time"],
    ['✔ Tasks (done)', :"✔_tasks_done"],
    ['_time', :time],
    [nil, :column3, 3],
    %i[first.name first_name],
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
