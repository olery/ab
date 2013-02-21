module Ab
  module ViewHelpers
    def ab(options={})
      Ab::Tester.new(options)
    end
  end
end
