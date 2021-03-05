# frozen_string_literal: true

require_relative "tiles"

module Roguelike
  using RichEngine::StringColors

  class GameMap
    attr_reader :tiles

    def initialize(width:, height:)
      @width = width
      @height = height
      @tiles = Array.new(width) { Array.new(height) { Tiles::Wall } }
    end

    def in_bounds?(x:, y:)
      x_in_bounds = (0...@width).cover? x
      y_in_bounds = (0...@height).cover? y

      x_in_bounds && y_in_bounds
    end

    def out_of_bounds?(x:, y:)
      !in_bounds?(x: x, y: y)
    end

    def walkable_tile?(x:, y:)
      @tiles[x][y].walkable
    end

    def render(canvas:)
      @tiles.each_with_index do |row, i|
        row.each_with_index do |tile, j|
          canvas[i, j] = tile.dark.to_s
        end
      end
    end
  end
end
