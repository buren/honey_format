require 'spec_helper'
require 'honey_format/convert_header_value'

describe HoneyFormat::ConvertHeaderValue do
  [
    ['first_name', :first_name],
    ['first name', :first_name],
    ['first name (user)', :'first_name(user)'],
    ['first name [user]', :'first_name[user]'],
    ['first name {user}', :'first_name{user}'],
    ['Billing City', :billing_city],
    ['Total Order Value (ex VAT)', :'total_order_value(ex_vat)'],
    ['VAT#', :'vat#'],
    ['   first_name  ', :first_name],
    ['ÅÄÖ', :'åäö'],
    ['first-name', :first_name],
    ['USeRnaMe', :username]
  ].each do |data|
    input, expected = data

    it "converts #{input} to #{expected}" do
      result = described_class.call(input)
      expect(result).to eq(expected)
    end
  end
end
