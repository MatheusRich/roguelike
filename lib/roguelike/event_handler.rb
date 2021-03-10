# frozen_string_literal: true

require_relative "actions"

module Roguelike
  class EventHandler
    def initialize(engine:)
      @engine = engine
    end

    def handle_events(key)
      action = action_from_key(key)

      return if action.nil?

      action.call
      @engine.handle_enemy_turns
      @engine.update_fov
    end

    def ev_quit(game)
      game.game_over!
    end

    # TODO: rename to on_keydown
    def action_from_key(key)
      player = @engine.player

      case key
      when :up      then BumpAction.new(entity: player, dx: 0, dy: -1)
      when :down    then BumpAction.new(entity: player, dx: 0, dy: 1)
      when :left    then BumpAction.new(entity: player, dx: -1, dy: 0)
      when :right   then BumpAction.new(entity: player, dx: 1, dy: 0)
      when :q, :esc then EscapeAction.new(entity: player)
      end
    end
  end
end
