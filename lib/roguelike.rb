# frozen_string_literal: true

require "rich_engine"
require "roguelike/analytics"
require "roguelike/engine"
require "roguelike/entity"
require "roguelike/event_handler"
require "roguelike/game_map"
require "roguelike/version"

module Roguelike
  class Exit < StandardError; end

  class Game < RichEngine::Game
    FPS = 30.0

    def on_create
      RichEngine::Terminal.hide_cursor
      RichEngine::Terminal.disable_echo

      @analitics = Analytics.new

      @canvas = RichEngine::Canvas.new(@width, @height, bg: ".")
      @game_over = false

      @map_width = 80
      @map_height = 25

      @player = Entity.new(x: @width / 2, y: @height / 2, char: "@", color: :white)
      @npc = Entity.new(x: @width / 2 - 5, y: @height / 2, char: "@", color: :red)

      @event_handler = EventHandler.new
      @game_map = GameMap.new(width: @map_width, height: @map_height)
      @engine = Engine.new(entities: [@player, @npc], event_handler: @event_handler, player: @player, game_map: @game_map)
    end

    def on_update(dt, key)
      @analitics.track_fps(dt)

      @engine.render(@canvas, @io)
      @io.write(@canvas.canvas)
      check_game_over { @engine.handle_events(key) }

      # sleep_time(dt)

      keep_playing?
    end

    def on_destroy
      RichEngine::Terminal.display_cursor
      RichEngine::Terminal.enable_echo

      @analitics.display_fps_stats
    end

    private

    def check_game_over
      yield
    rescue Roguelike::Exit
      game_over!
    end

    def sleep_time(dt)
      extra_time = (1 / FPS) - dt

      sleep [0, extra_time].max
    end

    def keep_playing?
      !@game_over
    end

    def game_over!
      @game_over = true
    end
  end
end
