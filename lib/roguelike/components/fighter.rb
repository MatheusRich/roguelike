# frozen_string_literal: true

require_relative "base_component"

module Roguelike
  module Components
    class Fighter
      include BaseComponent

      attr_reader :hp

      def initialize(hp:, defense:, power:)
        @max_hp = hp
        @hp = hp
        @defense = defense
        @power = power
      end

      def engine
        @engine ||= @entity.game_map.engine
      end

      def hp=(new_hp)
        @hp = new_hp.clamp(0, @max_hp)
      end
    end
  end
end
