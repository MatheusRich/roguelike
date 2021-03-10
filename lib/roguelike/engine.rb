# frozen_string_literal: true

require "roguelike/actions"

module Roguelike
  using RichEngine::StringColors

  class Engine
    PLAYER_FOV_RADIUS = 3.5

    attr_reader :game_map

    def initialize(event_handler:, player:, game_map:)
      @event_handler = event_handler
      @player = player
      @game_map = game_map

      update_fov
    end

    def handle_events(key)
      action = @event_handler.ev_keydown(key)

      return if action.nil?

      action.(engine: self, entity: @player)
      handle_enemy_turns
      update_fov
    end

    def render(canvas, io)
      canvas.clear

      @game_map.render(canvas: canvas)

      io.write(canvas.canvas)
    end

    private

    def handle_enemy_turns
      @game_map.entities.each do |entity|
        next if entity == @player

        Log.("The #{entity} wonders when it will get to take a real turn.")
      end
    end

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
