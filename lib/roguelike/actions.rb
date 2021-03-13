# frozen_string_literal: true

module Roguelike
  class Action
    def initialize(entity:)
      @entity = entity
    end

    def call
      raise NotImplementedError
    end

    def engine
      @entity.game_map.engine
    end

    def player?
      @entity == engine.player
    end
  end

  # TODO: Rename to `Exit`
  class EscapeAction < Action
    def call
      raise Game::Exit
    end
  end

  class WaitAction < Action
    def call; end
  end

  class ActionWithDirection < Action
    def initialize(entity:, dx:, dy:)
      super(entity: entity)
      @dx = dx
      @dy = dy
    end

    def call
      raise NotImplementedError
    end

    def dest_x
      @entity.x + @dx
    end

    def dest_y
      @entity.y + @dy
    end

    def dest_xy
      [dest_x, dest_y]
    end

    def blocking_entity
      engine.game_map.blocking_entity_at(x: dest_x, y: dest_y)
    end

    def target_actor
      engine.game_map.actor_at(x: dest_x, y: dest_y)
    end
  end

  class MovementAction < ActionWithDirection
    def call
      destination_x, destination_y = dest_xy

      return if engine.game_map.out_of_bounds?(x: destination_x, y: destination_y)
      return unless engine.game_map.walkable_tile?(x: destination_x, y: destination_y)
      return if engine.game_map.blocking_entity_at(x: destination_x, y: destination_y)

      @entity.move(dx: @dx, dy: @dy)
    end
  end

  class MeleeAction < ActionWithDirection
    def call
      target = target_actor or return

      damage = @entity.fighter.power - target.fighter.defense
      attack_description = "#{@entity.name.capitalize} attacks #{target.name}"

      if damage.positive?
        target.fighter.hp -= damage
        engine.log.add_message("#{attack_description} for #{damage} hit points.", fg: attack_color)
      else
        engine.log.add_message("#{attack_description} but does no damage.", fg: attack_color)
      end
    end

    private

    def attack_color
      player? ? UI::Color.player_atk : UI::Color.enemy_atk
    end
  end

  class BumpAction < ActionWithDirection
    def call
      has_target = !target_actor.nil?
      if has_target
        MeleeAction.new(entity: @entity, dx: @dx, dy: @dy).call
      else
        MovementAction.new(entity: @entity, dx: @dx, dy: @dy).call
      end
    end
  end
end
