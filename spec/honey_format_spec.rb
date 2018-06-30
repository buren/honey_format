# frozen_string_literal: true

RSpec.describe HoneyFormat do
  it 'has a version number' do
    version_pattern = /\A
        [[:digit:]]+ # 1 or more digits before the decimal point
        (\.          # Decimal point
            [[:digit:]]+ # 1 or more digits after the decimal point
        )
        (\.          # Decimal point
            [[:digit:]]+ # 1 or more digits after the decimal point
        )
    \Z/x
    expect(HoneyFormat::VERSION).to match(version_pattern)
  end

  it 'has a major version number' do
    expect(HoneyFormat::MAJOR_VERSION).not_to be nil
  end

  it 'has a minor version number' do
    expect(HoneyFormat::MINOR_VERSION).not_to be nil
  end

  it 'has a patch version number' do
    expect(HoneyFormat::PATCH_VERSION).not_to be nil
  end
end
