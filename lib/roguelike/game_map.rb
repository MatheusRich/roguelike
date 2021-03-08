# frozen_string_literal: true

require_relative "tiles"

module Roguelike
  using RichEngine::StringColors

  class GameMap
    attr_reader :tiles, :width, :height
    attr_accessor :visible, :explored

    def initialize(width:, height:)
      @width = width
      @height = height
      @tiles = RichEngine::Vec2.new(width: width, height: height, fill_with: Tiles::Wall)
      @visible = RichEngine::Vec2.new(width: width, height: height, fill_with: false)
      @explored = RichEngine::Vec2.new(width: width, height: height, fill_with: false)
    end

    def in_bounds?(x:, y:)
      x_in_bounds = x.between?(0, @width - 1)
      y_in_bounds = y.between?(0, @height - 1)

      x_in_bounds && y_in_bounds
    end

    def out_of_bounds?(x:, y:)
      !in_bounds?(x: x, y: y)
    end

    def walkable_tile?(x:, y:)
      @tiles[x, y].walkable
    end

    def render(canvas:)
      @tiles.each_with_indexes do |tile, i, j|
        canvas[i, j] = if visible?(i, j)
                         tile.light.to_s
                       elsif explored?(i, j)
                         tile.dark.to_s
                       else
                         Tiles::Shroud.dark.to_s
                       end
      end
    end

    def transparent_tiles
      # TODO: Is it safe to memoize this?
      @transparent_tiles ||= @tiles.map(&:transparent)
    end

    private

    def visible?(x, y)
      @visible[x, y]
    end

    def explored?(x, y)
      @explored[x, y]
    end
  end
end
