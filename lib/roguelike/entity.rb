# frozen_string_literal: true

require "securerandom"

module Roguelike
  class Entity
    attr_accessor :x, :y, :id, :char, :color, :name, :blocks_movement, :render_order#, :ai
    attr_reader :game_map

    def initialize(game_map: nil, x: 0, y: 0, char: "?", color: :white, name: "<Unnamed>", blocks_movement: false, render_order: RenderOrder.corpse)
      @id = new_id
      @x = x
      @y = y
      self.game_map = game_map if game_map
      @char = char
      @color = color
      @name = name
      @blocks_movement = blocks_movement
      @render_order = render_order
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
      clone = Calc.deep_clone(self)
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
      @game_map&.remove_entity(self)
      @game_map = new_map
      new_map.add_entity(self)
    end

    private

    def new_id
      SecureRandom.hex(6)
    end
  end
end
