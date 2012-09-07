



require 'ss2json/command'
require 'optparse'

class Humanize < SS2JSON::Command

  def self.name
    "humanize"
  end

  def self.description
    "Pretty print and sort (keys) on json"
  end

  def initialize(options)
    options = Options.new(options).options
    if options[:file]
      exec "python -mjson.tool < '#{options[:file]}'"
    else
      exec "python -mjson.tool"
    end
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
        opts.separator "\tThis tool use python -mjson.tool So you need python to be installed\n"

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
        @options[:file] = file
      end
    end

    def die(msg)
      $stderr.puts msg
      $stderr.puts @help
      exit -1
    end
  end

end
