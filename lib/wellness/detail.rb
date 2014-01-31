module Wellness
  # The parent class of all details that need to run.
  #
  # @author Matthew A. Johnston (warmwaffles)
  class Detail
    attr_reader :name, :options, :result

    def initialize(name, options={})
      @name = name
      @options = options
      @result = {}
    end

    def call
      @result = self.check
      self
    end

    # @return [Hash]
    def check
      {}
    end
  end
end