# frozen_string_literal: true

require_relative "game_map"

module Roguelike
  class RetangularRoom
    def initialize(x:, y:, width:, height:)
      @x1 = x
      @y1 = y
      @x2 = x + width
      @y2 = y + height
    end

    def center
      @center ||= begin
        center_x = (@x1 + @x2) / 2
        center_y = (@y1 + @y2) / 2

        [center_x, center_y]
      end
    end

    def inner
      @inner ||= [(@x1 + 1)...@x2, (@y1 + 1)...@y2]
    end
  end

  module Dungeoun
    def self.create(map_width:, map_height:)
      dungeoun = GameMap.new(width: map_width, height: map_height)

      room1 = RetangularRoom.new(x: 15, y: 7, width: 15, height: 10)
      room2 = RetangularRoom.new(x: 36, y: 7, width: 15, height: 10)

      dungeoun.tiles.fill(x: room1.inner[0], y: room1.inner[1], with: Tiles::Floor)
      dungeoun.tiles.fill(x: room2.inner[0], y: room2.inner[1], with: Tiles::Floor)

      # TODO: dungeoun.tiles.fill(coords: tunnel, with: Tiles::Floor)
      Tunnel.between(start: room1.center, end: room2.center).each do |(x, y)|
        dungeoun.tiles[x, y] = Tiles::Floor
      end

      dungeoun
    end
  end

  module Tunnel
    def self.between(start:, end:)
      x1, y1 = start
      x2, y2 = binding.local_variable_get(:end)

      if rand < 0.5 # 50% chance
        # Move horizontally, then vertically.
        corner_x = x2
        corner_y = y1
      else
        # Move vertically, then horizontally.
        corner_x = x1
        corner_y = y2
      end

      Enumerator.new do |enum|
        Calc.bresenham(x1: x1, y1: y1, x2: corner_x, y2: corner_y).to_a.each do |(x, y)|
          enum.yield([x, y])
        end

        Calc.bresenham(x1: corner_x, y1: corner_y, x2: x2, y2: y2).to_a.each do |(x, y)|
          enum.yield([x, y])
        end
      end
    end
  end
end
