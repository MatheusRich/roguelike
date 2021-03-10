# frozen_string_literal: true

require_relative "game_map"
require_relative "entity_factories"

module Roguelike
  module Dungeon
    extend self

    def create(max_rooms:, room_min_size:, room_max_size:, map_width:, map_height:, engine:, max_monsters_per_room:)
      player = engine.player
      dungeon = GameMap.new(engine: engine, width: map_width, height: map_height, entities: [player])
      rooms = []

      max_rooms.times do
        room_width = rand(room_min_size..room_max_size)
        room_height = rand(room_min_size..room_max_size)

        x = rand(0...(dungeon.width - room_width))
        y = rand(0...(dungeon.height - room_height))

        new_room = RetangularRoom.new(x: x, y: y, width: room_width, height: room_height)

        next if rooms.any? { |room| new_room.intersects?(room) }

        dungeon.tiles.fill(x: new_room.inner[0], y: new_room.inner[1], with: Tiles::Floor)

        if rooms.empty?
          room_x, room_y = new_room.center
          player.place(x: room_x, y: room_y, game_map: dungeon)
        else
          Tunnel.between(start: rooms.last.center, end: new_room.center).each do |x_pos, y_pos|
            dungeon.tiles[x_pos, y_pos] = Tiles::Floor
          end
        end

        place_entities(new_room, dungeon, max_monsters_per_room)

        rooms << new_room
      end

      dungeon
    end

    private

    def place_entities(room, dungeon, maximum_monsters)
      number_of_monsters = rand(0..maximum_monsters)

      number_of_monsters.times do
        x = rand((room.x1 + 1)..(room.x2 - 1))
        y = rand((room.y1 + 1)..(room.y2 - 1))

        next if dungeon.has_entity_at?(x: x, y: y)

        if rand < 0.8
          Orc.spawn(x: x, y: y, game_map: dungeon)
        else
          Troll.spawn(x: x, y: y, game_map: dungeon)
        end
      end
    end
  end

  module Tunnel
    def self.between(opts)
      x1, y1 = opts.fetch(:start)
      x2, y2 = opts.fetch(:end)

      if rand < 0.5
        # Move horizontally, then vertically.
        corner_x = x2
        corner_y = y1
      else
        # Move vertically, then horizontally.
        corner_x = x1
        corner_y = y2
      end

      Enumerator.new do |enum|
        Calc.bresenham_line(x1: x1, y1: y1, x2: corner_x, y2: corner_y).to_a.each do |x, y|
          enum.yield(x, y)
        end

        Calc.bresenham_line(x1: corner_x, y1: corner_y, x2: x2, y2: y2).to_a.each do |x, y|
          enum.yield(x, y)
        end
      end
    end
  end

  # TODO: Upstream as `Rect`
  class RetangularRoom
    attr_reader :x1, :y1, :x2, :y2, :width, :height

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

    def intersects?(other)
      @x1 <= other.x2 &&
        @x2 >= other.x1 &&
        @y1 <= other.y2 &&
        @y2 >= other.y1
    end
  end
end
