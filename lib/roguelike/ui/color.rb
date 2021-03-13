# frozen_string_literal: true

module Roguelike
  module UI
    module Color
      module_function

      def hp_bg
        :red
      end

      def hp_fg
        :green
      end

      def player_atk
        :white
      end

      def player_die
        :red
      end

      def enemy_atk
        :bright_red
      end

      def enemy_die
        :bright_magenta
      end
    end
  end
end
