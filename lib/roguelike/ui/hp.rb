# frozen_string_literal: true

module Roguelike
  module UI
    module HP
      using RichEngine::StringColors

      def self.render(canvas:, current:, max:, width: 50)
        life_bar_width = ((current.to_f / max) * width).floor

        canvas.draw_rect(x: 0, y: -1, width: width, height: 1, color: :red)
        canvas.draw_rect(x: 0, y: -1, width: life_bar_width, height: 1, color: :green)
        hp_text = "HP: #{current} / #{max}"
        colors = hp_text.size.times.map do |i|
          i < life_bar_width ? :green : :red
        end
        canvas.write_string(hp_text, x: 0, y: -1, bg_colors: colors)
      end
    end
  end
end
