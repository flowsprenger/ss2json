require 'optparse'

module Ss2Json

  class Options < OptionParser
    attr_reader :options
    DEFAULT_OPTIONS = {
      :first_row => 1,
      :sheet => nil,
      :file => nil,
      :check_column => nil,
      :action => :convert,
      :orientation => :horizontal,
      :key_column => 1,
      :value_column => 2,
      :converter => {
        :show_null => false,
        :dont_convert => false,
        :ignored_values => [],
        :downcase_first_letter => true
      }

    }

    def initialize(name, action, args)
      @options = DEFAULT_OPTIONS
      @help = nil
      super() do |opts|
        @help = opts

        if action==:hash
          opts.banner =  "Usage: #{name} FILENAME KEY [options]"
        else
          opts.banner =  "Usage: #{name} FILENAME [options]"
        end

        opts.on("-s", "--sheet SHEET_NAME", "Use other that the first table") do |sheet|
          @options[:sheet] = sheet
        end

        opts.on("-r", "--first-row ROW_NUMBER", "Set the first row") do |row|
          die("Can't understand the row #{row}. Use a number") unless row =~ /\A\d*\z/
          @options[:first_row] = row.to_i
        end

        opts.on("--dont-remove-key", "Don't remove key from the hash") do
          @options[:dont_remove_key] = true
        end if action==:hash


        if action==:vertical
          opts.on("-k", "--key-column COLUMN_NUMBER", "Column where the keys are (Default to 1)") do |column|
            die("Can't understand the column #{column}. Use a number") unless column =~ /\A\d*\z/
              @options[:key_column] = column.to_i
          end

          opts.on("-a", "--value-column COLUMN_NUMBER", "Column where the values are (Default to 2)") do |column|
            die("Can't understand the column #{column}. Use a number") unless column =~ /\A\d*\z/
              @options[:value_column] = column.to_i
          end
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


        if action!=:vertical
          opts.on("-c", "--check-column NAME", "Only output objects wich his property NAME is not in IGNORED VALUES") do |t|
            @options[:check_column] = t
          end
        end


        opts.separator "\n"

        opts.on_tail("-h","--help", "Show this help") do
          puts opts
          exit 0
        end

        opts.on_tail("--version", "Show the version") do
          puts "#{File.basename($0)} Version: #{Ss2Json::VERSION}"
          exit 0
        end

      end.parse!(args)

      if (action!=:hash && args.size == 1 || (action==:hash && args.size == 2))
        @options[:file] = args.first
        unless File.file?(@options[:file])
          $stderr.puts "File #{@options.file} not found"
          exit -5
        end
        @options[:hash_key] = args.last if action==:hash
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
