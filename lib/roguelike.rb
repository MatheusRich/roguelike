# frozen_string_literal: true

require "rich_engine"
require "roguelike/version"
require "roguelike/actions"
require "roguelike/entity"
require "roguelike/event_handler"

module Roguelike
  class Error < StandardError; end

  class Game < RichEngine::Game
    FPS = 1.0 / 60

    def on_create
      @canvas = RichEngine::Canvas.new(@width, @height, bg: ".")
      @game_over = false

      @player = Entity.new(x: @width / 2, y: @height / 2, char: "@", color: :white)
      @npc = Entity.new(x: @width / 2 - 5, y: @height / 2, char: "@", color: :yellow)

      @event_handler = EventHandler.new
    end

    def on_update(_dt, key)
      action = @event_handler.ev_keydown(key)

      if action.is_a? MovementAction
        @player.move(dx: action.dx, dy: action.dy)
      elsif action.is_a? EscapeAction
        game_over!
      end

      @canvas.clear
      @canvas[@player.x, @player.y] = @player.char
      render

      sleep 0.001

      keep_playing?
    end

    def render
      super
      puts "Yet Another Roguelike Tutorial"
    end

    def keep_playing?
      !@game_over
    end

    def game_over!
      @game_over = true
    end
  end
end
