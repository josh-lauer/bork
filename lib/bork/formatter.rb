module Bork
  module Formatter
    class << self
      def display_tests(*tests)
        max_test_index = (tests.length - 1).to_s.length
        tests.flatten.each_with_index do |test, i|
          display_index = "[#{i.to_s.rjust(max_test_index)}]"

          path = case test
          when Test
            colorized_test_path(test.path[Session.scope.length+1..-1], test)
          when String
            colorized_test_path(test[Session.scope.length+1..-1])
          else
            raise "NOT OK NOT OK"
          end

          puts "#{display_index} #{path}"
        end
        true
      end
      alias_method :display_test, :display_tests

      def colorized_test_path(path, status = nil)
        colorize(path, status_color(status))
      end

      # defaults to dark gray if falsy
      def status_color(test = nil)
        case
        when test.nil?                        then :dark_gray
        when test.disabled?                   then :blue
        when test.status.unattempted?         then :dark_gray
        when test.status.crashed?             then :magenta
        when test.status.passing?             then :green
        when test.status.failing_with_errors? then :yellow
        when test.status.failing?             then :red
        else                                       :white
        end
      end

      def status_line(test)
        raw_result = test.status.raw_result
        text = raw_result && "STATUS: " + raw_result.map { |p| p.reverse.join(' ')}.join(', ') || "Not completed - there was an error"
        colorize(text, status_color(test))
      end

      def color_print(str, *colors)
        print colorize(str, *colors)
      end

      def colorize(str, *colors)
        colors.reduce(str) { |memo, color| color_method(color).call(memo) }
      end

      def highlight(str, regex)
        str.gsub(regex) { colorize($&, :reverse_color) }
      end

      def color_method(color)
        COLORIZERS.key?(color.to_sym) && COLORIZERS[color.to_sym] || raise("invalid color code #{color.inspect}")
      end

      COLORIZERS = {
        black:         ->(str) { "\e[30m#{str}\e[0m" },
        red:           ->(str) { "\e[31m#{str}\e[0m" },
        green:         ->(str) { "\e[0;32m#{str}\e[0m" },
        yellow:        ->(str) { "\e[0;33m#{str}\e[0m" },
        beige:         ->(str) { "\e[1;33m#{str}\e[0m" },
        blue:          ->(str) { "\e[34m#{str}\e[0m" },
        magenta:       ->(str) { "\e[35m#{str}\e[0m" },
        cyan:          ->(str) { "\e[36m#{str}\e[0m" },
        gray:          ->(str) { "\e[0;37m#{str}\e[0m" },
        dark_gray:     ->(str) { "\e[1;30m#{str}\e[0m" },
        white:         ->(str) { "\e[1;37m#{str}\e[0m" },

        bg_black:      ->(str) { "\e[40m#{str}\e[0m" },
        bg_red:        ->(str) { "\e[41m#{str}\e[0m" },
        bg_green:      ->(str) { "\e[42m#{str}\e[0m" },
        bg_brown:      ->(str) { "\e[43m#{str}\e[0m" },
        bg_blue:       ->(str) { "\e[44m#{str}\e[0m" },
        bg_magenta:    ->(str) { "\e[45m#{str}\e[0m" },
        bg_cyan:       ->(str) { "\e[46m#{str}\e[0m" },
        bg_gray:       ->(str) { "\e[47m#{str}\e[0m" },

        bold:          ->(str) { "\e[1m#{str}\e[22m" },
        italic:        ->(str) { "\e[3m#{str}\e[23m" },
        underline:     ->(str) { "\e[4m#{str}\e[24m" },
        blink:         ->(str) { "\e[5m#{str}\e[25m" },
        reverse_color: ->(str) { "\e[7m#{str}\e[27m" }
      }

    end
  end
end
