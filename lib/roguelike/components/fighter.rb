# frozen_string_literal: true

require_relative "base_component"

module Roguelike
  module Components
    class Fighter
      include BaseComponent

      attr_reader :hp, :defense, :power

      def initialize(hp:, defense:, power:)
        @max_hp = hp
        @hp = hp
        @defense = defense
        @power = power
      end

      def engine
        @entity.game_map.engine
      end

      def hp=(new_hp)
        @hp = new_hp.clamp(0, @max_hp)

        die if hp.zero?
      end

      def die
        death_msg = player? ? "You died!" : "#{@entity.name} is dead!"

        @entity.char = "%"
        @entity.color = :red
        @entity.blocks_movement = false
        @entity.ai = nil
        @entity.name = "remains of #{@entity.name}"

        Log.(death_msg)
      end

      def player?
        self == engine.player
      end
    end
  end
end
