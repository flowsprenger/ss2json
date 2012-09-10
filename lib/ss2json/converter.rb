
require 'roo'
require 'ss2json/row_converter'

module SS2JSON
  class Converter

    # Create a new converter the options are:
    #
    #   * **:file** Input file.
    #   * **:sheet** Name of the sheet to use.
    #   * **:first_row** Which is the first row of real data
    #   * **:title_row** Where the title of the columns is.
    #   * **:check_column** Output only the results with a value present on the specific field.
    #   * **:key_column** Column of the keys for vertical mode.
    #   * **:value_column** Column of the values.
    #   * **:converter**: Options passed to the converter: Ss2Json::RowConverter
    def initialize(options={})
      @options = options
      @doc = get_document_type.new(@options[:file])
      set_default_sheet(@options[:sheet]) if @options[:sheet]
      set_header_line(@options[:title_row]) if @options[:title_row]
    end

    def process_horizontal
      @options[:first_row] += 1
      @content = []
      each_hash_row do |hash|
        @options[:hash_key]
        @content << hash
      end
      @content
    end


    def to_a
      @doc.to_matrix.to_a
    end

    def process_vertical
      hash = {}
      each_row do |row|
        key = @doc.cell(row, @options[:key_column])
        value = @doc.cell(row, @options[:value_column])
        hash[key] = value
      end
      @content = RowConverter.new(hash, @options[:converter])
      @content
    end

    def sheets
      @doc.sheets
    end

    protected

    def set_default_sheet(sheet)
      @doc.default_sheet = sheet
    rescue RangeError => e
      raise if @doc.sheets.include?(sheet)
      raise "\nThe sheet #{sheet} did not exists. The available sheets are:\n" + sheets.map{|s| "\t* #{s}\n"}.join("")
    end

    def set_header_line(first_row)
      @doc.header_line = first_row
    end

    def each_row
      (@options[:first_row]).upto(@doc.last_row).each do |row_n|
        yield row_n
      end
    end

    def each_hash_row
      each_row do |row|
        row = @doc.find(row)[0]
        object = RowConverter.new( row, @options[:converter] )
        # TODO: Fix nested_hash to make set and get work on already converted items
        next if @options[:check_column] && object[@options[:check_column]].nil?
        yield object
      end
    end

    def get_document_type
      case @options[:file][/\.(.*)$/,1]
      when /xlsx$/i then Excelx
      when /xls$/i then Excel
      when /ods$/i then Openoffice
      when /csv$/i then Csv
      else
        raise "Unknown format"
      end
    end

  end
end
