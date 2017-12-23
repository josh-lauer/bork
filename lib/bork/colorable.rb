module Bork
  module Colorable
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
