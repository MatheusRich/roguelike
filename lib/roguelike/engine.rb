# frozen_string_literal: true

require "set"
require "roguelike/actions"

module Roguelike
  using RichEngine::StringColors

  class Engine
    PLAYER_FOV_RADIUS = 3.5

    attr_reader :game_map

    def initialize(entities:, event_handler:, player:, game_map:)
      @entities = entities.to_set
      @event_handler = event_handler
      @player = player
      @game_map = game_map

      update_fov
    end

    def handle_events(key)
      action = @event_handler.ev_keydown(key)

      return if action.nil?

      action.call(engine: self, entity: @player)
      update_fov
    end

    def render(canvas, io)
      canvas.clear

      @game_map.render(canvas: canvas)

      @entities.each do |entity|
        entity_tile_fg = @game_map.tiles[entity.x, entity.y].light.fg
        canvas[entity.x, entity.y] = entity.char.bold.send(entity.color).bg(entity_tile_fg)
      end

      io.write(canvas.canvas)
    end

    private

    def update_fov
      @game_map.visible.vec = Calc.fov(
        transparent_tiles: @game_map.transparent_tiles,
        pov:               @player.coords,
        radius:            PLAYER_FOV_RADIUS
      )

      update_explored_tiles
    end

    def update_explored_tiles
      @game_map.explored.vec = @game_map.explored.zip(@game_map.visible).map(&:any?)
    end
  end
end
