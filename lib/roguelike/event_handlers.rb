# frozen_string_literal: true

require_relative "actions"

module Roguelike
  class EventHandler
    MOVEMENT_KEYS = {
      up:    { dx: 0,  dy: -1 },
      down:  { dx: 0,  dy: 1 },
      left:  { dx: -1, dy: 0 },
      right: { dx: 1,  dy: 0 }
    }.freeze
    EXIT_KEYS = %i[q esc].to_set
    WAIT_KEYS = %i[enter space].to_set

    def initialize(engine:)
      @engine = engine
    end

    def handle_events(_key)
      # raise NotImplementedError
    end

    def on_render(canvas)
      @engine.render(canvas)
    end

    def player
      @engine.player
    end
  end

  class MainGameEventHandler < EventHandler
    # TODO: rename to on_keydown
    def handle_events(key)
      action = action_from_key(key) or return

      action.call
      @engine.handle_enemy_turns
      @engine.update_fov
    end

    private

    def action_from_key(key)
      if MOVEMENT_KEYS.include?(key)
        BumpAction.new(entity: player, **MOVEMENT_KEYS[key])
      elsif EXIT_KEYS.include?(key)
        EscapeAction.new(entity: player)
      elsif WAIT_KEYS.include?(key)
        WaitAction.new(entity: player)
      end
    end
  end

  class GameOverEventHandler < EventHandler
    def handle_events(key)
      action = action_from_key(key) or return

      action.call
    end

    private

    def action_from_key(key)
      EscapeAction.new(entity: player) if EXIT_KEYS.include?(key)
    end
  end
end
