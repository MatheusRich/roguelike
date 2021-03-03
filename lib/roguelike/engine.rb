# frozen_string_literal: true

require "set"
require "roguelike/actions"

module Roguelike
  using RichEngine::StringColors

  class Engine
    def initialize(entities:, event_handler:, player:, game_map:)
      @entities = entities.to_set
      @event_handler = event_handler
      @player = player
      @game_map = game_map
    end

    def handle_events(key)
      action = @event_handler.ev_keydown(key)

      if action.is_a? MovementAction
        if walkable_tile?(x: @player.x + action.dx, y: @player.y + action.dy)
          @player.move(dx: action.dx, dy: action.dy)
        end
      elsif action.is_a? EscapeAction
        raise Roguelike::Exit
      end
    end

    def render(canvas, io)
      canvas.clear

      @game_map.render(canvas: canvas)

      @entities.each do |entity|
        canvas[entity.x, entity.y] = entity.char.send(entity.color).on_black
      end

      io.write(canvas.canvas)
    end

    private

    def walkable_tile?(x:, y:)
      @game_map.tiles[x][y].walkable
    end
  end
end
