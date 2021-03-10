# frozen_string_literal: true

require "securerandom"

module Roguelike
  class Entity
    attr_accessor :x, :y, :id
    attr_reader :char, :color, :name, :blocks_movement, :game_map

    def initialize(game_map: nil, x: 0, y: 0, char: "?", color: :white, name: "<Unnamed>", blocks_movement: false)
      @id = new_id
      @x = x
      @y = y
      @game_map = game_map
      @char = char
      @color = color
      @name = name
      @blocks_movement = blocks_movement

      @game_map.entities.add(self) if game_map
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
      clone.game_map = game_map

      clone
    end

    def place(x:, y:, game_map: nil)
      @x = x
      @y = y

      return if game_map.nil?

      self.game_map = game_map
    end

    def to_s
      @to_s ||= "#{name}:#{id}"
    end

    def game_map=(new_map)
      @game_map&.entities&.delete(self)
      @game_map = new_map
      new_map.entities.add(self)
    end

    private

    def new_id
      SecureRandom.hex(6)
    end
  end
end
