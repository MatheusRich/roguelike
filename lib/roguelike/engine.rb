# frozen_string_literal: true

require "set"
require "roguelike/actions"

module Roguelike
  using RichEngine::StringColors

  class Engine
    def initialize(entities:, event_handler:, player:)
      @entities = entities.to_set
      @event_handler = event_handler
      @player = player
    end

    def handle_events(key)
      action = @event_handler.ev_keydown(key)

      if action.is_a? MovementAction
        @player.move(dx: action.dx, dy: action.dy)
      elsif action.is_a? EscapeAction
        raise Roguelike::Exit
      end
    end

    def render(canvas, io)
      canvas.clear

      @entities.each do |entity|
        canvas[entity.x, entity.y] = entity.char.send(entity.color)
      end

      io.write(canvas.canvas)
    end
  end
end
