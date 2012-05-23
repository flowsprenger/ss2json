require 'nested_hash'

class Ss2Json
  class RowConverter < NestedHash

    # Create a nested_hash from a hash with just one level (key,value).
    #
    # The options are:
    #
    #   * **:ignored_values** Array of ignored values.
    #   * **:show_null** Export the keys with empty values.
    #   * **:dont_convert** Convert 10.0 float values to integers.
    #   * **:downcase_first_letter** Convert to downcase the first letter of each key.
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

    def sanitize_key(key)
      key
    end

  end
end
