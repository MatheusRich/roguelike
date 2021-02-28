# frozen_string_literal: true

require "rich_engine"
require "roguelike/version"

module Roguelike
  class Error < StandardError; end

  class Game < RichEngine::Game
    FPS = 1.0 / 60

    def on_create
      @canvas = RichEngine::Canvas.new(@width, @height, bg: ".")
      @game_over = false

      @player_x = @width / 2
      @player_y = @height / 2
    end

    def on_update(_dt, key)
      @game_over = key == :q

      @canvas.clear

      @canvas[@player_x, @player_y] = "@"
      # @canvas.write_string("Yet Another Roguelike Tutorial", x: 0, y: 0)
      render

      # sleep [FPS - dt, 0].max
      sleep 0.001

      !@game_over
    end

    def render
      super
      puts "Yet Another Roguelike Tutorial"
    end
  end
end
