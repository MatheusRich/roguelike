# frozen_string_literal: true

module Roguelike
  class Entity
    attr_accessor :x, :y
    attr_reader :char, :color

    def initialize(x: 0, y: 0, char: "?", color: :white, name: "<Unnamed>", blocks_movement: false)
      @x = x
      @y = y
      @char = char
      @color = color
      @name = name
      @blocks_movement = blocks_movement
    end

    def move(dx:, dy:)
      @x += dx
      @y += dy
    end

    def coords
      [@x, @y]
    end
    alias position coords

    def spawn(game_map:, x:, y:)
      clone = dup
      clone.x = x
      clone.y = y
      game_map.entities.add(clone)

      clone
    end
  end
end
