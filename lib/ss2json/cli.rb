require 'roo'
require 'json'


class Ss2Json
  class Cli
    attr_reader :content, :doc

    # Parse the options from ARGV, initialize the conversion, and return the string with the output
    def self.start
      options = Ss2Json::Options.parse!
      converter =  new(options)
      case options[:action]
      when :list
        converter.doc.sheets.join("\n")
      else
        JSON.pretty_generate(converter.content)
      end
    end

    # Create a new converter the options are:
    #
    #   * **:file** Input file.
    #   * **:sheet** Name of the sheet to use.
    #   * **:first_row** Where the title of the columns is.
    #   * **:check_column** Output only the results with a value present on the specific field.
    #   * **:orientation** The data orientation (:horizontal/:vertical).
    #   * **:key_column** Column of the keys for vertical mode.
    #   * **:value_column** Column of the values.
    #   * **:action** Could
    #     * *:convert* Do the normal conversion.
    #     * *:list* Will list the sheets.
    #   * **:converter**: Options passed to the converter: Ss2Json::RowConverter
    def initialize(options)
      @options = options
      init_document
      if options[:action] == :list
        @doc.sheets.join("\n")
      else
        if options[:orientation] == :horizontal
          process_horizontal
        elsif options[:orientation] == :vertical
          process_vertical
        else
          raise "Orientation #{options[:orientation]} not recognized"
        end
      end
    end

    protected

    def init_document
      @doc = open
      begin
      @doc.default_sheet = @options[:sheet] if @options[:sheet]
      rescue RangeError => e
        raise if @doc.sheets.include?(@options[:sheet])
        raise "\nThe sheet #{@options[:sheet]} did not exists. The available sheets are:\n" + @doc.sheets.map{|s| "\t* #{s}\n"}.join("")
      end
      @doc.header_line = @options[:first_row] if @options[:first_row]
    end

    def process_horizontal
      @content = []
      (@options[:first_row]+1).upto(@doc.last_row).each do |row_n|
        row = @doc.find(row_n)[0]
        object = RowConverter.new(row, @options[:converter])
        if @options[:check_column]
          next unless object[@options[:check_column]]
        end
        @content << object
      end
    end

    def process_vertical
      hash = {}
      @options[:first_row].upto(@doc.last_row) do |row|
        key = @doc.cell(row, @options[:key_column])
        value = @doc.cell(row, @options[:value_column])
        hash[key] = value
      end
      @content = RowConverter.new(hash, @options[:converter])
    end


    def open
      kclass = case @options[:file][/\.(.*)$/,1]
               when /xlsx$/i then Excelx
               when /xls$/i then Excel
               when /ods$/i then Openoffice
               else
                 raise "Unknown format"
               end
      kclass.new(@options[:file])
    end
  end
end
