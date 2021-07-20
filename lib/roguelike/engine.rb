# frozen_string_literal: true

require_relative "actions"
require_relative "event_handlers"
require_relative "ui/hp"
require_relative "ui/log"
require_relative "ui/names_at"

module Roguelike
  using RichEngine::StringColors

  class Engine
    PLAYER_FOV_RADIUS = 5

    attr_reader :player, :log
    attr_accessor :game_map, :event_handler

    def initialize(player:)
      @event_handler = MainGameEventHandler.new(engine: self)
      @player = player
      @log = UI::Log.new
    end

    def render(canvas)
      @game_map.render(canvas: canvas)
      render_log(canvas)
      render_hp(canvas)
      render_names(canvas)
    end

    def render_log(canvas)
      @log.render(canvas: canvas, x: 55, y: -5, width: 45, height: 5)
    end

    def render_hp(canvas)
      UI::HP.render(canvas: canvas, x: 0, y: -1, current: @player.fighter.hp, max: @player.fighter.max_hp)
    end

    def render_names(canvas)
      names = UI::NamesAt.(x: @player.x, y: @player.y, game_map: @game_map)
      canvas.write_string(names, x: 0, y: -2)
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
