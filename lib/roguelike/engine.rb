# frozen_string_literal: true

require "set"
require "roguelike/actions"

module Roguelike
  using RichEngine::StringColors

  class Engine
    PLAYER_FOV_RADIUS = 2.5

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
        canvas[entity.x, entity.y] = entity.char.send(entity.color).on_blue
      end

      io.write(canvas.canvas)
    end

    private

    def update_fov
      @game_map.visible.vec = compute_fov(
        transparent_tiles: @game_map.visible.vec,
        pov:               @player.coords,
        radius:            PLAYER_FOV_RADIUS
      )

      merge_explored_tiles_with_visible_tiles
    end

    def compute_fov(transparent_tiles:, pov:, radius:)
      pov_x, pov_y = pov
      start_x = [pov_x - radius, 0].max
      start_y = [pov_y - radius, 0].max

      end_x = [pov_x + radius, transparent_tiles.size].min
      end_y = [pov_y + radius, transparent_tiles.size].min

      transparent_tiles.map.with_index do |line, i|
        line.map.with_index do |value, j|
          if i.between?(start_x, end_x) && j.between?(start_y, end_y)
            distance_to_pov = Calc.distance_between_points(x1: i, y1: j, x2: pov_x, y2: pov_y)

            distance_to_pov <= radius
          else
            value
          end
        end
      end
    end

    def merge_explored_tiles_with_visible_tiles
      @game_map.explored.vec = @game_map.explored.zip(@game_map.visible).map(&:any?)
    end
  end
end
