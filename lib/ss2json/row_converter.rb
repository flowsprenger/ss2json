require 'nested_hash'

class Ss2Json
  class RowConverter < NestedHash

    def initialize(hash, options={})
      @options = options
      super(hash)
    end

    protected

    def is_valid_key?(key)
      super && ! (key =~ /^i\./i)
    end

    def copy_invalid_keys?
      false
    end

    def sanitize_value(v)
      return v if @options[:dont_convert]
    end

    def process(key,value)
      super if valid_value?(value)
    end

    def valid_value?(value)
      !@options[:ignored_values].include?(value) &&
        (@options[:show_null] || value )
    end

    def sanitize_value(v)
      return v if @options[:dont_convert]
      return v.to_i if v.is_a?(Float) && v % 1 == 0
      v
    end

  end
end
