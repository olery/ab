require "olery_ab/version"
require "digest/sha1"

#
# Overall Idea:
#
# ab_test(:options=>[true, false], :chance=>"1/1", :input=>user.id) do |result|
#   if result
#
#   end
# end
#
#
# ab_test(:options=>["a", "b", "c"], :chance=>"1/1/2", :input=>user.id) do |result|
#   render_partial("version_#{result}")
# end
#
#
module Olery
  module AB
    module Test
      def ab_test(options={})
        Tester.new(options)
      end
    end


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
        @indexer.call(:value=>id,:chances=>chances, :seed=>name)
      end

      private
      def defaults
        { :options=>[true,false],
          :chances=>"50/50",
          :name=>"Please provide me a name",
          :indexer=>IntIndexer.new }
      end
    end

    class IntIndexer

      def self.call(opts={})
        value = opts[:value].to_s
        chances = opts[:chances]
        salt = opts[:seed].to_s

        seed = Digest::SHA1.hexdigest(salt + value).to_i
        rand = Random.new(seed).rand(100)


        sum = 0
        chances.each_index do |index|
          min = sum
          max = chances[index] + sum

          if (min..max).include?(rand)
            return index
          end

          sum = max
        end
      end

    end

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
        array.map{|e| e * factor}.map(&:to_i)
      end

      def self.split_chance(string)
        string.split("/").map(&:to_i)
      end

      def validate_raw_chances(chances)
        chances.each do |chance|
          raise ArgumentError if chance < 0
        end
      end

      def count
        chances.count
      end
    end
  end
end

#if Kernel.const_get(:ActiveSupport)
  #ActiveSupport.on_load(:action_view) do
    #include Olery::AB::Tester
  #end
#end
