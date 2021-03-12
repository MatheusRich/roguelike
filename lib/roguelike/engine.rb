# frozen_string_literal: true

require "roguelike/actions"
require "roguelike/event_handlers"

module Roguelike
  using RichEngine::StringColors

  class Engine
    PLAYER_FOV_RADIUS = 5

    attr_reader :player, :event_handler
    attr_accessor :game_map

    def initialize(player:)
      @event_handler = MainGameEventHandler.new(engine: self)
      @player = player
    end

    def render(canvas, io)
      canvas.clear

      @game_map.render(canvas: canvas)
      canvas.write_string("HP: #{@player.fighter.hp} / #{@player.fighter.max_hp} ", x: 1, y: -1)

      io.write(canvas.canvas)
    end

    def handle_enemy_turns
      @game_map.actors.each do |actor|
        next if actor == @player

        actor.ai&.call
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

    private

    def update_explored_tiles
      @game_map.explored.vec = @game_map.explored.zip(@game_map.visible).map(&:any?)
    end
  end
end
