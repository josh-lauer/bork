module Bork
  class Status
    attr_accessor :raw_result, :finished, :attempted, :completed

    def unattempted?
      !attempted?
    end

    # whether running the test file has been attempted, regardless of outcome
    def attempted?
      !!attempted
    end

    # whether the test has run to completion and gotten results, regardless of outcome
    def completed?
      !!completed
    end

    def crashed?
      attempted? && !completed?
    end

    # true if the unit has run to completion free of any test failures or errors
    def passing?
      completed? && !has_failures? && !has_errors?
    end

    # true if the unit has run to completion and encountered failures and/or errors
    def failing?
      completed? && has_failures? || has_errors?
    end

    # true if the unit has run to completion and encountered failures and/or errors
    def failing_with_errors?
      completed? && has_failures? && has_errors?
    end

    # tests failed via unmet assertions
    def has_failures?
      completed? && @raw_result['failures'] != '0'
    end

    def has_errors?
      completed? && @raw_result['errors'] != '0'
    end

    def has_pendings?
      completed? && @raw_result['pendings'] != '0'
    end

    def has_omissions?
      completed? && @raw_result['omissions'] != '0'
    end

    def has_notifications?
      completed? && @raw_result['notifications'] != '0'
    end
  end
end
