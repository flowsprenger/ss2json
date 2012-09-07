require 'ss2json/command'
require 'optparse'
require 'json'

class Merge < SS2JSON::Command

  def self.name
    "merge"
  end

  def self.description
    "Merge a list of json in a single file"
  end

  def initialize(options)
    options = Options.new(options).options
    global_hash = {}
    options[:files].each do |file|
      begin
        json = JSON.parse(File.read(file))
      rescue => e
        die "Could not read the file #{file}"
        exit -1
      end
      key = File.basename(file).split(".").first
      global_hash[key] = json
    end
    output = options[:compress] ? JSON.dump(global_hash) : JSON.pretty_generate(global_hash)
    puts output
  end

  class Options < ::OptionParser
    attr_reader :options
    DEFAULT_OPTIONS = { }

    def initialize(args)
      @options = DEFAULT_OPTIONS
      opts = super() do |opts|
        @help = opts

        opts.banner =  "Usage: #{$0} filename1 [filename2] [filename3]... "

        opts.separator "\n"
# \nmerge_jsons will receive several files as an arguments and will generate
# and write to the stdout the a json hash with the name of the filename
# (without the extension) as a key, and the content of the file as a value
# for each file passed.

        opts.on_tail("-h","--help", "Show this help") do
          puts opts
          exit 0
        end

        opts.on("-c","--compress", "Output a compressed json") do
          @options[:compress] = true
        end

        opts.on_tail("--version", "Show the version") do
          require 'ss2json/version'
          puts "#{$0} Version: #{SS2JSON::VERSION}"
          exit 0
        end

      end
      opts.parse!(args)

      if args.size < 1
        die "You should provide a list of files"
      end

      @options[:files] = args

      @options[:files].each do |f|
        File.file?(f) or die("File #{f} not found")
      end


    end

    def die(msg)
      $stderr.puts msg
      $stderr.puts @help
      exit -1
    end
  end

end
