require 'nested_hash'

module Ss2Json
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

    def set(key,value)
      super if valid_value?(value)
    end

    def valid_value?(value)
      @options[:show_null] || !ignored_values.include?(value)
    end

    def ignored_values
      (@options[:ignored_values] || []) << nil
    end


    def sanitize_value(v)
      return v if @options[:dont_convert]
      return v.to_i if v.is_a?(Float) && v % 1 == 0
      return true if v == "true"
      return false if v == "false"
      v
    end

    def sanitize_key(key)
      key = super(key)
      return key unless is_valid_key?(key) && key.is_a?(String)
      key = key[0..1].downcase + (key[2..-1] || "") if @options[:downcase_first_letter]
      key
    end

  end
end
