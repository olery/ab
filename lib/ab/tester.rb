module Ab
  class Tester
    attr_reader :options, :chances, :input, :name

    def initialize(opts={})
      opts = defaults.merge!(opts)

      @options = opts[:options]
      @chances = Chance.new(opts[:chances])
      @input = opts[:input]
      @indexer = opts[:indexer]
      @name = opts[:name]
    end

    def valid?
      chances.count == options.count
    end

    def validate!
      raise ArgumentError unless valid?
    end

    def call(id)
      validate!
      index = @indexer.call(:value=>id,:chances=>chances.to_a, :seed=>name)
      if block_given?
        yield options[index]
      else
        return options[index]
      end
    end
    alias_method :for, :call

    private
    def defaults
      { :options=>[true,false],
        :chances=>"50/50",
        :name=>"Please provide me a name",
        :indexer=>Indexer }
    end
  end
end
