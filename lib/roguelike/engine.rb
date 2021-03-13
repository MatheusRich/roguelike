# frozen_string_literal: true

require "roguelike/actions"
require "roguelike/event_handlers"
require "roguelike/ui/hp"

module Roguelike
  using RichEngine::StringColors

  class Engine
    PLAYER_FOV_RADIUS = 5

    attr_reader :player
    attr_accessor :game_map, :event_handler

    def initialize(player:)
      @event_handler = MainGameEventHandler.new(engine: self)
      @player = player
    end

    def render(canvas, io)
      canvas.clear

      @game_map.render(canvas: canvas)
      render_hp(canvas)

      io.write(canvas.canvas)
    end

    def render_hp(canvas)
      UI::HP.render(canvas: canvas, x: 0, y: -1, current: @player.fighter.hp, max: @player.fighter.max_hp)
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
