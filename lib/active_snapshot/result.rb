require "activerecord-import"

module ActiveSnapshot
  class Result
    attr_reader :ar_class, :columns, :values

    # ar_result is an ActiveRecord::Result
    def self.build_from_ar_result(ar_class, ar_result)
      self.new(ar_class: ar_class, columns: ar_result.columns, values: ar_result.rows)
    end

    def initialize(ar_class: , columns: , values: )
      @ar_class, @columns, @values = ar_class, columns, values
    end

    def apply
      @ar_class.import(@columns, @values, validate: false)
    end
  end
end
