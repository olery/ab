module Ab
  class Indexer
    def self.call(opts={})
      validate_options(opts)

      value = opts[:value].to_s
      chances = opts[:chances]
      salt = opts[:seed].to_s

      seed = Digest::SHA1.hexdigest(salt + value).to_i
      random_number = Randomizer.new(seed).rand(1..100)

      sum = 0
      chances.each_index do |index|
        min = sum
        max = chances[index] + sum

        if (min..max).include?(random_number)
          return index
        end

        sum = max
      end
      raise IndexError.new("Could not resolve any index for the given chances")
    end

    private

    def self.validate_options(opts)
      keys = [:value, :chances, :seed]
      keys.each do |key|
        raise ArgumentError.new("Missing option: :#{key}") if opts[key].nil?
      end

      if opts[:chances].reduce(&:+)==0
        raise ArgumentError.new("Chances does not actually contain any chance")
      end
    end

    class Randomizer
      attr_reader :randomizer

      def initialize(seed)
        if RUBY_VERSION =~ /^1.8/
          @randomizer = OneEight.new(seed)
        else
          @randomizer = Random.new(seed)
        end
      end

      def rand(value)
        randomizer.rand(value)
      end

      private

      class OneEight
        def initialize(seed)
          srand(seed)
        end

        def rand(value)
          if value.kind_of?(Range)
            first = value.first
            last = value.last - first
            return Kernel::rand(last) + first
          else
            Kernel::rand(value)
          end
        end
      end
    end
  end
end
