# frozen_string_literal: true

module Roguelike
  module UI
    module NamesAt
      extend self

      def call(x:, y:, game_map:)
        return " " if game_map.out_of_bounds?(x: x, y: y)
        return " " unless game_map.visible?(x, y)

        game_map.entities_at(x: x, y: y).map(&:name).join(", ").capitalize
      end
    end
  end
end
