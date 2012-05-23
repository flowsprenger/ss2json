require 'roo'
require 'json'


class Ss2Json
  class Cli
    attr_reader :content, :doc

    # Parse the options from ARGV, initialize the conversion, and return the string with the output
    def self.start
      options = Ss2Json::Options.parse!
      converter =  new(options)
      if options[:action] == :list
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
        process_document
      end
    end

    protected

    def init_document
      @doc = open
      @doc.default_sheet = @options[:sheet] if @options[:sheet]
      @doc.header_line = @options[:first_row] if @options[:first_row]
    end

    def process_document
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


    def open
      kclass = case @options[:file][/\.(.*)$/,1]
               when /xlsx/i then Excelx
               when /ods/i then Openoffice
               else
                 raise "Unknown format"
               end
      kclass.new(@options[:file])
    end
  end
end
