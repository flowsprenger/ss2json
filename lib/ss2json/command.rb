module SS2JSON
  class Command

    @commands = []
    def self.load_all
      require 'rubygems' unless defined?(Gem)
      Gem.find_files('ss2json-commands/*.rb').each do |file|
        require(file)
      end
      @commands
    end

    def self.commands
      @commands
    end

    def self.inherited(kclass)
      @commands << kclass
    end
  end
end

