# frozen_string_literal: true

require_relative "base_component"

module Roguelike
  module Components
    class Fighter
      include BaseComponent

      attr_reader :hp, :max_hp, :defense, :power

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
        if player?
          death_msg = "You died!"
          engine.event_handler = GameOverEventHandler.new(engine: engine)
        else
          death_msg = "#{@entity.name} is dead!"
        end

        @entity.char = "%"
        @entity.color = :red
        @entity.blocks_movement = false
        @entity.ai = nil
        @entity.name = "remains of #{@entity.name}"
        @entity.render_order = RenderOrder.corpse

        Log.(death_msg)
      end

      def player?
        @entity == engine.player
      end
    end
  end
end
