# frozen_string_literal: true

require "set"
require_relative "tiles"

module Roguelike
  using RichEngine::StringColors

  class GameMap
    # TODO: Some getters could be specific methods, like `each_entity`
    attr_reader :tiles, :width, :height, :entities, :engine
    attr_accessor :visible, :explored

    def initialize(engine:, width:, height:, entities:)
      @engine = engine
      @width = width
      @height = height
      @entities = entities.to_set
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

      @entities.sort_by(&:render_order).each do |entity|
        next unless visible?(entity.x, entity.y)

        entity_tile_fg = @tiles[entity.x, entity.y].light.fg
        canvas[entity.x, entity.y] = entity.char.bold.send(entity.color).bg(entity_tile_fg)
      end
    end

    def transparent_tiles
      # TODO: Is it safe to memoize this?
      @transparent_tiles ||= @tiles.map(&:transparent)
    end

    def add_entity(new_entity)
      @entities.add(new_entity)
    end

    def remove_entity(entity)
      @entities.delete(entity)
    end

    def entity_at(x:, y:)
      @entities.find { |entity| entity.x == x && entity.y == y }
    end

    def blocking_entity_at(x:, y:)
      entity = entity_at(x: x, y: y)

      return entity if entity&.blocks_movement
    end

    def has_entity_at?(x:, y:)
      !!entity_at(x: x, y: y)
    end

    def actors
      Enumerator.new do |enumerator|
        @entities.each do |entity|
          enumerator.yield(entity) if entity.is_a?(Actor) && entity.alive?
        end
      end
    end

    def actor_at(x:, y:)
      actors.find { |actor| actor.x == x && actor.y == y }
    end

    def visible?(x, y)
      @visible[x, y]
    end

    private

    def explored?(x, y)
      @explored[x, y]
    end
  end
end
