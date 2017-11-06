require "stringio"
require "logger"
require "timeout"
require "open3"
require "benchmark"
require 'ostruct'
require 'fileutils'

module Bork
  class Runner
    # args/options:
    # command - a shell command to run, or array of strings to be joined into a command
    # job_dir - a folder in which to write logs and status code
    # echo - a flag to turn on/off stdout echo to terminal, defaults to true
    def run(command, job_dir, opts = {})
      options = OpenStruct.new(Config.defaults.merge(opts))

      puts "RUN OPTIONS: #{options.inspect}"

      # make the job dir if it doesn't exist
      FileUtils.mkdir_p(job_dir) unless Dir.exist?(job_dir)

      # empty the job dir before running
      FileUtils.rm_f Dir.glob(File.join(job_dir, '*'))

      stderr_log = File.join(job_dir, 'stderr.log')
      stdout_log = File.join(job_dir, 'stdout.log')
      all_log    = File.join(job_dir, 'all.log')
      status_log = File.join(job_dir, 'status')

      command = "((#{[*command].flatten.compact.join(' ')} | tee #{stdout_log}) 3>&1 1>&2 2>&3 | tee #{stderr_log}) 2>&1 | tee #{all_log}"

      puts "RUNNING COMMAND: #{command}"

      begin
        Timeout.timeout(options.timeout) do
          # run the command, record the exit status, return true if 0, else false
          options.echo ? system(command) : `#{command}`
          $?.exitstatus.tap do |status|
            File.open(status_log, 'w') { |f| f.write(status) }
          end == 0
        end
      rescue Timeout::Error
        puts "RUNNER ABORTED, TIMED OUT! (> #{options.timeout}s elapsed)"
        # Process.kill("KILL", thread.pid)
      end

      # elapsed = Benchmark.realtime do
      #   Open3.popen3(*command) do |stdin, stdout, stderr, thread|
      #     begin
      #       Timeout.timeout(options.timeout) do
      #         threads = []
      #         threads << Thread.new do
      #           while line = stdout.gets do
      #             puts line if options.echo
      #           end
      #         end
      #         threads << Thread.new do
      #           while line = stderr.gets do
      #             puts line if options.echo
      #           end
      #         end
      #         # threads << Thread.new do
      #         #   while line = STDIN.read(64)  # read output of the upstream command
      #         #     puts "PASSING THROUGH INPUT: #{line.inspect}"
      #         #     stdin.write(line)          # manually pipe it to the ffmpeg command
      #         #   end
      #         # end
      #         threads.each(&:join)
      #       end
      #     rescue Timeout::Error
      #       puts "RUNNER ABORTED, TIMED OUT! (> #{options.timeout}s elapsed)"
      #       Process.kill("KILL", thread.pid)
      #     end
      #   end
      # end
    end
  end
end
