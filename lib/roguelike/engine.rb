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
        canvas[entity.x, entity.y] = entity.char.send(entity.color).on_yellow
      end

      io.write(canvas.canvas)
    end

    private

    def update_fov
      @game_map.visible.vec = compute_fov(
        transparent_tiles: @game_map.transparent_tiles,
        pov:               @player.coords,
        radius:            PLAYER_FOV_RADIUS
      )

      update_explored_tiles
    end

    def compute_fov(transparent_tiles:, pov:, radius:)
      pov_x, pov_y = pov
      fov_min_x = [pov_x - radius, 0].max
      fov_min_y = [pov_y - radius, 0].max

      fov_max_x = [pov_x + radius, transparent_tiles.size].min
      fov_max_y = [pov_y + radius, transparent_tiles.size].min

      transparent_tiles.map.with_index do |line, i|
        line.map.with_index do |_is_transparent, j|
          is_inside_fov = i.between?(fov_min_x, fov_max_x) && j.between?(fov_min_y, fov_max_y)
          if is_inside_fov
            distance_to_pov = Calc.distance_between_points(x1: i, y1: j, x2: pov_x, y2: pov_y)

            distance_to_pov <= radius
          else
            false
          end
        end
      end
    end

    def update_explored_tiles
      @game_map.explored.vec = @game_map.explored.zip(@game_map.visible).map(&:any?)
    end
  end
end
