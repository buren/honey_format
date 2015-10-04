module HoneyFormat
  class Row
    def initialize(columns)
      @klass = Struct.new(*columns)
    end

    def build(row)
      @klass.new(*row)
    end
  end
end
