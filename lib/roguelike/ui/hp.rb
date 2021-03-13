# frozen_string_literal: true

module Roguelike
  module UI
    module HP
      using RichEngine::StringColors

      def self.render(canvas:, x:, y:, current:, max:, width: 50)
        life_bar_width = ((current.to_f / max) * width).floor

        canvas.draw_rect(x: x, y: y, width: width, height: 1, color: Color.hp_bg)
        canvas.draw_rect(x: x, y: y, width: life_bar_width, height: 1, color: Color.hp_fg)
        hp_text = "HP: #{current} / #{max}"
        bg_colors = hp_text.size.times.map do |i|
          i < life_bar_width ? Color.hp_fg : Color.hp_bg
        end
        canvas.write_string(hp_text, x: x, y: y, bg: bg_colors)
      end
    end
  end
end
