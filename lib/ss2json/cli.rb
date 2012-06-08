require 'json'


module Ss2Json
  class CLI
    MAP={
      "ss2json-vertical" => :vertical,
      "ss2json-horizontal" => :horizontal,
      "ss2json-horizontal-hash" => :hash
    }

    def initialize(cmd,args)
      case cmd
      when *MAP.keys
        options = Ss2Json::Options.new(cmd,MAP[cmd], args).options
        converter = Ss2Json::Converter.new(options)
        content = converter.send(:"process_#{MAP[cmd]}")
        puts JSON.pretty_generate(content)
      when "merge-jsons"
        merge_jsons(args)
      when "order-json"
        if $stdin.tty?
          exec "python -mjson.tool < #{args.first}"
        else
          exec "python -mjson.tool "
        end
      when "compress-json"
        require 'json'
        puts JSON.parse(File.read(args.first)).to_json
      when "catss"
        options = {:file => args.shift, :sheet => args.shift }
        converter = Ss2Json::Converter.new(options)
        require 'terminal-table'
        puts ::Terminal::Table.new :rows => converter.to_a
      when "lsss"
        options = {:file => args.first}
        converter = Ss2Json::Converter.new(options)
        puts converter.sheets.join("\n")
      else
        $stderr.puts "Command #{cmd} not recognize"
        exit -1
      end
      exit 0
    end

    def merge_jsons(args)
      unless (args.size >= 1 && args.all?{|f| File.file?(f)})
        $stderr.puts "Usage: #{File.basename($0)} file1.json file2.json ..."
        $stderr.puts <<-EOF
\nmerge_jsons will receive several files as an arguments and will generate
and write to the stdout the a json hash with the name of the filename
(without the extension) as a key, and the content of the file as a value
for each file passed.
        EOF
        exit -1
      end

      require 'json'

      global_hash = {}

      args.each do |file|
        begin
          json = JSON.parse(File.read(file))
        rescue => e
          $stderr.puts "Could not parse or read the file #{file}"
          exit -1
        end

        key = File.basename(file).split(".").first
        global_hash[key] = json

      end

      puts JSON.pretty_generate(global_hash)
    end

  end
end

