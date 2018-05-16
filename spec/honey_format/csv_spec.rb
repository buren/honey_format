require 'spec_helper'

describe HoneyFormat::CSV do
  let(:csv_string) {
<<-CSV
email, ids
test@example.com,42
CSV
  }

let(:diabolical_csv) {
<<-CSV
"Email Address","First Name","Last Name",MEMBER_RATING,OPTIN_TIME,OPTIN_IP,CONFIRM_TIME,CONFIRM_IP,LATITUDE,LONGITUDE,GMTOFF,DSTOFF,TIMEZONE,CC,REGION,LAST_CHANGED,LEID,EUID,NOTES
mail@example.com,,,2,,,"2015-03-16 14:40:47",,,,,,,,,"2015-03-16 14:40:47",some-value,some-other-value,
CSV
}

let(:diabolical_cols) {
  [:email_address,
   :first_name,
   :last_name,
   :member_rating,
   :optin_time,
   :optin_ip,
   :confirm_time,
   :confirm_ip,
   :latitude,
   :longitude,
   :gmtoff,
   :dstoff,
   :timezone,
   :cc,
   :region,
   :last_changed,
   :leid,
   :euid,
   :notes]
}

  describe 'missing header' do
    it 'should fail' do
      expect { described_class.new('') }.to raise_error(HoneyFormat::MissingCSVHeaderError)
    end
  end

  describe 'with specified header' do
    it 'returns correct csv object' do
      csv_string = "1,buren"
      csv = described_class.new(csv_string, header: ['Id', 'Username'])
      expect(csv.rows.first.username).to eq('buren')
    end
  end

  describe '#each_row' do
    it 'yields each row' do
      csv = described_class.new("email, ids\ntest@example.com,42")
      csv.each_row do |row|
        expect(row.email).to eq('test@example.com')
        expect(row.ids).to eq('42')
      end
    end
  end

  describe '#header' do
    it 'returns a CSVs header' do
      result = described_class.new(csv_string).header
      expect(result).to eq(%w(email ids))
    end

    it 'can validate and return when all headers are valid in valid_columns' do
      result = described_class.new(csv_string, valid_columns: [:email, :ids]).header
      expect(result).to eq(%w(email ids))
    end
  end

  describe '#columns' do
    it 'returns correct columns for a diabolical CSV' do
      result = described_class.new(diabolical_csv).columns
      expect(result).to eq(diabolical_cols)
    end
  end

  describe '#rows' do
    it 'returns CSV rows' do
      csv = described_class.new(csv_string).rows
      expect(csv.first.email).to eq('test@example.com')
      expect(csv.first.ids).to eq('42')
    end

    it 'returns CSV rows and ignores empty lines' do
      csv = described_class.new("#{csv_string}\n\n\ntest1@example.com,73").rows
      expect(csv.first.email).to eq('test@example.com')
      expect(csv.first.ids).to eq('42')
      expect(csv.to_a.last.email).to eq('test1@example.com')
      expect(csv.to_a.last.ids).to eq('73')
    end

    it 'works for a diabolical example' do
      result = described_class.new(diabolical_csv).rows.first
      expect(result.confirm_time).to eq('2015-03-16 14:40:47')
      expect(result.leid).to eq('some-value')
      expect(result.euid).to eq('some-other-value')
    end
  end

  it 'can handle alternative delimiters' do
    csv = <<-CSV
    email; ids
    test@example.com; 42
    CSV
    result = described_class.new(csv, delimiter: ';').header
    expect(result).to eq(%w(email ids))
  end

  describe '#to_csv' do
    it 'returns a CSV-string' do
      csv_string = "1,buren"
      csv = described_class.new(csv_string, header: ['Id', 'Username'])
      expect(csv.to_csv).to eq("Id,Username\n1,buren\n")
    end

    it 'returns a valid CSV-string even if values needs special quoting' do
      csv_string = '1,"jacob ""buren"" burenstam"'
      csv = described_class.new(csv_string, header: ['Id', 'Username'])
      expected = <<~CSV
      Id,Username\n1,"jacob ""buren"" burenstam"
      CSV
      expect(csv.to_csv).to eq(expected)
    end

    it 'returns a CSV-string with values changed by custom row builder' do
      csv_string = "1,buren"
      upcase_builder = Class.new do
        def self.call(row)
          row.username = row.username.upcase
          row
        end
      end

      csv = described_class.new(
        csv_string,
        header: ['Id', 'Username'],
        row_builder: upcase_builder
      )
      expect(csv.to_csv).to eq("Id,Username\n1,BUREN\n")
    end
  end
end
