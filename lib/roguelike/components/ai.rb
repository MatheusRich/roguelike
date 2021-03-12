# frozen_string_literal: true

require_relative "base_component"
require_relative "../actions"

module Roguelike
  module Components
    class BaseAI < Action
      include BaseComponent

      def call
        raise NotImplementedError
      end

      # TODO: This is NOT using any smart pathfinder. Update it later!
      def path_to(x:, y:)
        x_signal = x / [x.abs, 1].max
        y_signal = y / [y.abs, 1].max

        if x.abs > y.abs
          [[1 * x_signal, 0]]
        elsif x.zero? && y.zero?
          [[0, 0]]
        else
          [[0, 1 * y_signal]]
        end
      end
    end

    class HostileEnemy < BaseAI
      def initialize(entity:)
        super(entity: entity)
        @path = []
      end

      def call
        target_x, target_y = engine.player.coords
        dx = target_x - @entity.x
        dy = target_y - @entity.y

        if engine.game_map.visible?(*@entity.coords)
          return MeleeAction.new(entity: @entity, dx: dx, dy: dy).call if target_near?(target_x, target_y)

          @path = path_to(x: dx, y: dy)
        end

        unless @path.empty?
          dest_x, dest_y = @path.pop

          return MovementAction.new(entity: @entity, dx: dest_x, dy: dest_y).call
        end

        WaitAction.new(entity: @entity).call
      end

      private

      def target_near?(target_x, target_y)
        # TODO: maybe use point_distance here
        distance = Calc.chebyshev_distance(x1: target_x, y1: target_y, x2: @entity.x, y2: @entity.y)

        distance <= 1
      end
    end
  end
end
