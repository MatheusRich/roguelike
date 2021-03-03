# frozen_string_literal: true

require "set"
require "roguelike/actions"

module Roguelike
  using RichEngine::StringColors

  class Engine
    attr_reader :game_map

    def initialize(entities:, event_handler:, player:, game_map:)
      @entities = entities.to_set
      @event_handler = event_handler
      @player = player
      @game_map = game_map
    end

    def handle_events(key)
      action = @event_handler.ev_keydown(key)

      action.call(engine: self, entity: @player)
    end

    def render(canvas, io)
      canvas.clear

      @game_map.render(canvas: canvas)

      @entities.each do |entity|
        canvas[entity.x, entity.y] = entity.char.send(entity.color).on_black
      end

      io.write(canvas.canvas)
    end
  end
end
