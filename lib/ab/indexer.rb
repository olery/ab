module Ab
  class Indexer
    def self.call(opts={})
      validate_options(opts)

      value = opts[:value].to_s
      chances = opts[:chances]
      salt = opts[:seed].to_s

      seed = Digest::SHA1.hexdigest(salt + value).to_i
      rand = Random.new(seed).rand(1..100)

      sum = 0
      chances.each_index do |index|
        min = sum
        max = chances[index] + sum

        if (min..max).include?(rand)
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
  end
end
