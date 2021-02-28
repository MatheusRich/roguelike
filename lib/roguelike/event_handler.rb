# frozen_string_literal: true

require_relative "actions"

class EventHandler
  def ev_quit(game)
    game.game_over!
  end

  def ev_keydown(key)
    case key
    when :up
      MovementAction.new(dx: 0, dy: -1)
    when :down
      MovementAction.new(dx: 0, dy: 1)
    when :left
      MovementAction.new(dx: -1, dy: 0)
    when :right
      MovementAction.new(dx: 1, dy: 0)
    when :q
      EscapeAction.new
    else
      NoAction.new
    end
  end
end
