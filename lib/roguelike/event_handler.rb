# frozen_string_literal: true

require_relative "actions"

module Roguelike
  class EventHandler
    def ev_quit(game)
      game.game_over!
    end

    # TODO: rename to on_keydown
    def ev_keydown(key)
      case key
      when :up
        BumpAction.new(dx: 0, dy: -1)
      when :down
        BumpAction.new(dx: 0, dy: 1)
      when :left
        BumpAction.new(dx: -1, dy: 0)
      when :right
        BumpAction.new(dx: 1, dy: 0)
      when :q, :esc
        EscapeAction.new
      end
    end
  end
end
