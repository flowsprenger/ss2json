
require 'ss2json/command'
require 'ss2json/converter'
require 'optparse'
require 'json'

class ToHash < SS2JSON::Command

  def self.name
    "to_hash"
  end

  def self.description
    "Convert a spreadsheet to a json hash usign one column as a key"
  end

  def initialize(options)
    options = Options.new(options).options
    output = Converter.new(options).process
    puts JSON.pretty_generate(output)
  end

  class Options < ::OptionParser
    attr_reader :options
    DEFAULT_OPTIONS = {
      :title_row => 1,
      :first_row => 2,
      :sheet => nil,
      :file => nil,
      :key_column => 1,
      :value_column => 2,
      :header_line => 1,
      :converter => {
        :show_null => false,
        :dont_convert => false,
        :ignored_values => [],
        :ignored_keys => [],
        :downcase_first_letter => true
      }
    }

    def initialize(args)
      @options = DEFAULT_OPTIONS
      @help = nil
      super() do |opts|
        @help = opts

        opts.banner =  "Usage: #{$0} FILENAME KEY [options]"

        opts.on("-s", "--sheet SHEET_NAME", "Use other that the first table") do |sheet|
          @options[:sheet] = sheet
        end

        opts.on("-t", "--title-row ROW_NUMBER", "Row in wich the titles are. Default: #{DEFAULT_OPTIONS[:title_row]}") do |row|
          die("Can't understand the row #{row}. Use a number") unless row =~ /\A\d*\z/
          @options[:title_row] = row.to_i
        end

        opts.on("-r", "--first-row ROW_NUMBER", "Set the first row of real data. Default: #{DEFAULT_OPTIONS[:first_row]}") do |row|
          die("Can't understand the row #{row}. Use a number") unless row =~ /\A\d*\z/
          @options[:first_row] = row.to_i
        end

        opts.on("-n", "--dont-remove-key", "When using a column in the excel as a key for the hash, that column is removed. This option avoid that behaviour") do
          @options[:dont_remove_key] = true
        end

        opts.separator "\nData options:"

        opts.on("-i", "--ignore-value VALUE", "Ignore the fields with that value. Could be use several times") do |t|
          @options[:converter][:ignored_values] << t
        end

# TODO
#        opts.on("-i", "--ignore-key VALUE", "Ignore the fields with that key. Could be use several times") do |t|
#          @options[:converter][:ignored_keys] << t
#        end

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
          require 'ss2json/version'
          puts "#{$0} Version: #{SS2JSON::VERSION}"
          exit 0
        end

      end.parse!(args)

      if args.size == 2
        @options[:file] = args.first
        unless File.file?(@options[:file])
          $stderr.puts "File #{@options.file} not found"
          exit -5
        end
        @options[:hash_key] = args.last
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
      @content = {}
      each_hash_row do |hash|
        if value = hash.get(@options[:hash_key])
          hash.delete(@options[:hash_key]) unless @options[:dont_remove_key]
          @content[value] = hash
        end
      end
      @content
    end
  end
end
