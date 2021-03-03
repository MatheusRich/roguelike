# frozen_string_literal: true

require "rich_engine"
require "roguelike/version"
require "roguelike/engine"
require "roguelike/entity"
require "roguelike/event_handler"

module Roguelike
  class Exit < StandardError; end

  class Game < RichEngine::Game
    FPS = 30

    def on_create
      @canvas = RichEngine::Canvas.new(@width, @height, bg: ".")
      @game_over = false

      @player = Entity.new(x: @width / 2, y: @height / 2, char: "@", color: :white)
      @npc = Entity.new(x: @width / 2 - 5, y: @height / 2, char: "@", color: :red)

      @event_handler = EventHandler.new
      @engine = Engine.new(entities: [@player, @npc], event_handler: @event_handler, player: @player)
    end

    def on_update(_dt, key)
      @engine.render(@canvas, @io)
      check_game_over { @engine.handle_events(key) }

      sleep 1 / FPS

      keep_playing?
    end

    private

    def check_game_over
      yield
    rescue Roguelike::Exit
      game_over!
    end

    def keep_playing?
      !@game_over
    end

    def game_over!
      @game_over = true
    end
  end
end
