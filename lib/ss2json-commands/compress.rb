require 'ss2json/command'
require 'optparse'

class Compress < SS2JSON::Command

  def self.name
    "compress"
  end

  def self.description
    "Uglify a json file (DO NOT RESPECT ORDER)"
  end

  def initialize(options)
    options = Options.new(options).options
    puts JSON.parse(options[:file].read).to_json
  ensure
    options[:file].close if options[:file]
  end

  class Options < ::OptionParser
    attr_reader :options
    DEFAULT_OPTIONS = {
      :sheet => nil,
      :file => nil,
    }

    def initialize(args)
      @options = DEFAULT_OPTIONS
      opts = super() do |opts|
        @help = opts

        opts.banner =  "Usage: #{$0} [FILENAME]"

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

      end
      opts.parse!(args)

      if args.size > 1
        file = args.first
        File.file?(file) or die("File #{file} not found")
        @options[:file] = File.open(file)
      else
        @options[:file] = $stdin
      end
    end

    def die(msg)
      $stderr.puts msg
      $stderr.puts @help
      exit -1
    end
  end

end
