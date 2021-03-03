# frozen_string_literal: true

module Roguelike
  class Action
    def call(entity:, engine:)
      raise NotImplementedError
    end
  end

  class EscapeAction < Action
    def call(*)
      raise Roguelike::Exit
    end
  end

  class NoAction < Action
    def call(*); end
  end

  class MovementAction < Action
    def initialize(dx:, dy:)
      @dx = dx
      @dy = dy
    end

    def call(entity:, engine:)
      destination_x = entity.x + @dx
      destination_y = entity.y + @dy

      return if engine.game_map.out_of_bounds?(x: destination_x, y: destination_y)
      return unless engine.game_map.walkable_tile?(x: destination_x, y: destination_y)

      entity.move(dx: @dx, dy: @dy)
    end
  end
end
