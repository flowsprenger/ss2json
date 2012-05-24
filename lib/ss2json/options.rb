require 'optparse'

class Ss2Json

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

    def self.parse!
      new.options
    end

    def initialize
      @options = DEFAULT_OPTIONS
      @help = nil
      super do |opts|
        @help = opts

        opts.banner =  "Usage: #{File.basename $0} -f FILENAME [options]"

        opts.separator "\nMode options:"

        opts.on("-h", "--horizontal", "Normal processing mode (DEFAULT). Can be ommited") do
          @options[:orientation] = :horizontal
        end

        opts.on("-v", "--vertical", "Process the spreadhsheet on vertical") do
          @options[:orientation] = :vertical
        end

        opts.on("-l", "--list-sheets", "Return the list of sheets") do |file|
          @options[:action] = :list
        end

        opts.separator "Common options:"

        opts.on("-f", "--file FILENAME", "Use the filename") do |file|
          File.file?(file) or die("Can't find the file #{file}.")
          @options[:file] = File.expand_path(file)
        end

        opts.on("-s", "--sheet SHEET_NAME", "Use other that the first table") do |sheet|
          @options[:sheet] = sheet
        end

        opts.separator "\nHorizontal and Vertical mode options:"
        opts.on("-r", "--first-row ROW_NUMBER", "Set the first row") do |row|
          die("Can't understand the row #{row}. Use a number") unless row =~ /\A\d*\z/
          @options[:first_row] = row.to_i
        end

        opts.separator "\nVertical mode options:"

        opts.on("-k", "--key-column", "Column where the keys are (Default to 1)") do |column|
          die("Can't understand the column #{column}. Use a number") unless column =~ /\A\d*\z/
          @options[:key_column] = column.to_i
        end

        opts.on("-a", "--value-column", "Column where the values are (Default to 2)") do |column|
          die("Can't understand the column #{column}. Use a number") unless column =~ /\A\d*\z/
          @options[:value_column] = column.to_i
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

        opts.separator "\nFilter options:"

        opts.on("-c", "--check-column NAME", "Only output objects wich his property NAME is not in IGNORED VALUES") do |t|
          @options[:check_column] = t
        end


        opts.separator ""



        opts.separator ""

        opts.on_tail("-h","--help", "Show this help") do
          puts opts
          exit 0
        end
      end.parse!

      die("You need to at least specify a file") if @options[:file].nil?
    end

    def die(msg)
      $stderr.puts msg
      $stderr.puts @help
      exit -1
    end
  end

end
