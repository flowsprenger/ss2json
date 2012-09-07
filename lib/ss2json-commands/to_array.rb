
require 'ss2json/command'
require 'ss2json/converter'
require 'optparse'
require 'json'

class ToArray < SS2JSON::Command

  def self.name
    "to_array"
  end

  def self.description
    "Convert a spreadsheet to a json array, respecting the order in wich the rows are."
  end

  def initialize(options)
    options = Options.new(options).options
    output = Converter.new(options).process
    puts JSON.pretty_generate(output)
  end

  class Options < OptionParser
    attr_reader :options
    DEFAULT_OPTIONS = {
      :title_row => 1,
      :first_row => 2,
      :sheet => nil,
      :file => nil,
      :check_column => nil,
      :key_column => 1,
      :value_column => 2,
      :converter => {
        :show_null => false,
        :dont_convert => false,
        :ignored_values => [],
        :downcase_first_letter => true
      }

    }

    def initialize(args)
      @options = DEFAULT_OPTIONS
      @help = nil
      super() do |opts|
        @help = opts

        opts.banner =  "Usage: #{$0} FILENAME [options]"

        opts.on("-s", "--sheet SHEET_NAME", "Use other that the first table") do |sheet|
          @options[:sheet] = sheet
        end

        opts.on("-t", "--title-row ROW_NUMBER", "Row in wich the titles are. Default: #{DEFAULT_OPTIONS[:title_row]}") do |row|
          die("Can't understand the row #{row}. Use a number") unless row =~ /\A\d*\z/
          @options[:title_row] = row.to_i
        end

        opts.on("-r", "--first-row ROW_NUMBER", "Set the first row") do |row|
          die("Can't understand the row #{row}. Use a number") unless row =~ /\A\d*\z/
          @options[:first_row] = row.to_i
        end

        opts.on("-c", "--check-column NAME", "Only output objects wich his property NAME is not in IGNORED VALUES") do |t|
          @options[:check_column] = t
        end

        opts.separator "\nData options:"

        opts.on("-i", "--ignore-value VALUE", "Ignore the fields with that value. Could be use several times") do |t|
          @options[:converter][:ignored_values] << t
        end

        opts.on("-b", "--include-blank", "Generate a json with the values included in the ignore list") do |t|
          @options[:converter][:show_null] = true
        end

        opts.on("-d", "--disable-conversion", "Disable the conversion from floats to integers") do
          @options[:converter][:dont_convert] = true
        end

        opts.on("-l", "--disable-first-letter", "Will disable the downcase of the first letter of the key") do
          @options[:converter][:downcase_first_letter] = false
        end

        opts.separator "\n"

        opts.on_tail("-h","--help", "Show this help") do
          puts opts
          exit 0
        end

        opts.on_tail("--version", "Show the version") do
          puts "#{File.basename($0)} Version: #{SS2JSON::VERSION}"
          exit 0
        end

      end.parse!(args)

      if (args.size == 1)
        @options[:file] = args.first
        unless File.file?(@options[:file])
          $stderr.puts "File #{@options.file} not found"
          exit -5
        end
      else
        die("Incorrect number of parameters")
      end
    end

    def die(msg)
      $stderr.puts msg
      $stderr.puts @help
      exit -1
    end
  end

  class Converter < SS2JSON::Converter
    def process
      @options[:first_row] += 1
      @content = []
      each_hash_row do |hash|
        @content << hash
      end
      @content
    end
  end
end
