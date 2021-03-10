# frozen_string_literal: true

module Roguelike
  class Action
    def call(entity:, engine:)
      raise NotImplementedError
    end
  end

  # TODO: Rename to `Exit`
  class EscapeAction < Action
    def call(*)
      raise Game::Exit
    end
  end

  class ActionWithDirection < Action
    def initialize(dx:, dy:)
      @dx = dx
      @dy = dy
    end

    def call(entity:, engine:)
      raise NotImplementedError
    end
  end

  class MovementAction < ActionWithDirection
    def call(entity:, engine:)
      destination_x = entity.x + @dx
      destination_y = entity.y + @dy

      return if engine.game_map.out_of_bounds?(x: destination_x, y: destination_y)
      return unless engine.game_map.walkable_tile?(x: destination_x, y: destination_y)
      return if engine.game_map.blocking_entity_at(x: destination_x, y: destination_y)

      entity.move(dx: @dx, dy: @dy)
    end
  end

  class MeleeAction < ActionWithDirection
    def call(entity:, engine:)
      destination_x = entity.x + @dx
      destination_y = entity.y + @dy

      target = engine.game_map.blocking_entity_at(x: destination_x, y: destination_y)
      return if target.nil?

      Log.("You kick the #{target.name}, much to its annoyance!")
    end
  end

  class BumpAction < ActionWithDirection
    def call(entity:, engine:)
      destination_x = entity.x + @dx
      destination_y = entity.y + @dy

      has_target = engine.game_map.blocking_entity_at(x: destination_x, y: destination_y)
      if has_target
        MeleeAction.new(dx: @dx, dy: @dy).call(entity: entity, engine: engine)
      else
        MovementAction.new(dx: @dx, dy: @dy).call(entity: entity, engine: engine)
      end
    end
  end
end
