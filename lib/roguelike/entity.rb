# frozen_string_literal: true

require 'securerandom'

module Roguelike
  class Entity
    attr_accessor :x, :y, :id
    attr_reader :char, :color, :name, :blocks_movement

    def initialize(x: 0, y: 0, char: "?", color: :white, name: "<Unnamed>", blocks_movement: false)
      @id = new_id
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
      clone.id = new_id
      clone.x = x
      clone.y = y
      game_map.entities.add(clone)

      clone
    end

    def to_s
      @to_s ||= "#{name}:#{id}"
    end

    private

    def new_id
      SecureRandom.hex(6)
    end
  end
end
