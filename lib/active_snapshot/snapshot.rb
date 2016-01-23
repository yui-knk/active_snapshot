module ActiveSnapshot
  class Snapshot
    attr_reader :results

    # ActiveSnapshot::Result
    def initialize(results)
      @results = results
    end

    def apply
      # Transaction?
      @results.each(&:apply)
    end
  end
end
