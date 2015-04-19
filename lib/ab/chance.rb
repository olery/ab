module Ab
  class Chance
    attr_reader :chances

    def initialize(chance_string)
      raw_chances = self.class.split_chance(chance_string)
      validate_raw_chances(raw_chances)

      @chances = self.class.normalize(raw_chances)
    end

    def self.normalize(array)
      sum = array.reduce(&:+)
      factor = 100.to_f / sum
      normalized_chances = array.map{|e| e * factor}.map(&:to_i)
      normalized_sum = normalized_chances.reduce(&:+)

      # Check if sum of chances is 100.
      # If it is not, add +1 to each chance (from last to first)
      # until it reaches 100.
      unless normalized_sum == 100
        index = array.count - 1
        (100 - normalized_sum).times do
          normalized_chances[index] += 1
          index = index < 0 ? array.count - 1 : index - 1
        end
      end
      
      return normalized_chances
    end

    def self.split_chance(string)
      string.split("/").map(&:to_i)
    end

    def validate_raw_chances(chances)
      chances.each do |chance|
        raise ArgumentError.new("chance should be > 0") if chance < 0
      end
    end

    def count
      chances.count
    end

    def to_a
      chances
    end
  end
end
