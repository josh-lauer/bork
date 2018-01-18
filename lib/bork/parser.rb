module Bork
  class Parser
    attr_reader :job_dir

    def initialize(job_dir)
      @job_dir = job_dir
    end

    def parse
      status = Status.new

      if Dir.exist?(job_dir) && File.exist?(all_log)
        line = status_line
        if line
          status.attempted = true
          status.completed = true
          status.raw_result = parse_result_line(line)
        else
          status.attempted = true
          status.completed = false
        end
      else
        status.attempted = false
        status.completed = false
      end

      status
    end

    # Return the first line in the test output that matches the first of the status_line_regexes
    #  returns nil if none is found
    def raw_status_line
      status_line_regexes.detect do |status_line_regex|
        status_line = output_lines.detect { |line| clean_line(line) =~ status_line_regex }
        break status_line if status_line
      end
    end

    def status_line
      raw_status_line && clean_line(raw_status_line)
    end

    def output_lines
      IO.readlines(all_log)
    end

    def status_line_regexes
      [
        /^.*[0-9]+\stests.*assertions.*failures.*errors.*pendings.*omissions.*notifications.*$/, # Test::Unit
        /^.*[0-9]+\stests.*assertions.*failures.*errors.*skips.*$/                               # Minitest
      ]
    end

    def clean_line(line)
      # remove escape codes and strips line
      line.gsub(/\e\[([;\d]+)?m/, '').strip
    end

    def parse_result_line(line)
      Hash[line.split(',').map { |pair| pair.strip.split.reverse }] #.reject { |e| e[1] == "0" }]
    end

    def all_log
      File.join(job_dir, 'all.log')
    end
  end
end
