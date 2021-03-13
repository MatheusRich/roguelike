# frozen_string_literal: true

require "rich_engine"
require "roguelike/analytics"
require "roguelike/ui/color"
require "roguelike/engine"
require "roguelike/render_order"
require "roguelike/entity"
require "roguelike/entity_factories"
require "roguelike/game_map"
require "roguelike/procgen"
require "roguelike/version"

module Roguelike
  class Game < RichEngine::Game
    FPS = 60

    def on_create
      @analitics = Analytics.new if debug?

      @canvas = RichEngine::Canvas.new(@width, @height, bg: " ")
      @game_over = false

      map_width = @width
      map_height = @height - 5

      room_max_size = 10
      room_min_size = 6
      max_rooms = 8

      max_monsters_per_room = 2

      player = Calc.deep_clone(Player)

      @engine = Engine.new(player: player)
      @engine.game_map = Dungeon.create(
        engine:                @engine,
        max_rooms:             max_rooms,
        map_width:             map_width,
        map_height:            map_height,
        room_min_size:         room_min_size,
        room_max_size:         room_max_size,
        max_monsters_per_room: max_monsters_per_room
      )

      @engine.update_fov

      @engine.log.add_message(
        "Hello and welcome, adventurer, to yet another dungeon!", fg: :blue
      )
    end

    def on_update(dt, key)
      @analitics.track_fps(dt) if debug?

      @engine.render(@canvas, @io)
      @io.write(@canvas.canvas)
      @engine.event_handler.handle_events(key)

      sleep_time(dt) unless debug?

      keep_playing?
    end

    def on_destroy
      @analitics.display_fps_stats if debug?
    end

    private

    def sleep_time(dt)
      extra_time = (1.0 / FPS) - dt

      sleep [0, extra_time].max
    end

    def keep_playing?
      !@game_over
    end

    def game_over!
      @game_over = true
    end

    def debug?
      ENV["DEBUG"]
    end
  end
end
