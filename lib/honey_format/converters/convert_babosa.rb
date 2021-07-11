# frozen_string_literal: true

BABOSA_LOADED = begin
                  require 'babosa'
                  true
                rescue LoadError
                  false
                end

module HoneyFormat
  # Convert to babosa or nil
  ConvertBabosa = proc do |v|
    unless BABOSA_LOADED
      raise(Errors::BabosaNotLoadedError, "unable to require 'babosa' gem, please install")
    end

    return unless v

    begin
      v.to_identifier.to_ruby_method.downcase.to_sym
    rescue Babosa::Identifier::Error
      nil
    end
  end
end
