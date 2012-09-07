



require 'ss2json/command'
require 'ss2json/converter'
require 'optparse'
require 'terminal-table'
require 'json'

class Ls < SS2JSON::Command

  def self.name
    "ls"
  end

  def self.description
    "List SpreadSheet. List the sheets included in the spreadsheet."
  end

  def initialize(options)
    options = Options.new(options).options
    converter = SS2JSON::Converter.new(options)
    converter = SS2JSON::Converter.new(options)
    puts converter.sheets.join("\n")
  end

  class Options < ::OptionParser
    attr_reader :options
    DEFAULT_OPTIONS = {
      :sheet => nil,
      :file => nil,
    }

    def initialize(args)
      @options = DEFAULT_OPTIONS
      @help = nil
      super() do |opts|
        @help = opts

        opts.banner =  "Usage: #{$0} FILENAME"

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

      if file = args.shift
        @options[:file] = file
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

end
