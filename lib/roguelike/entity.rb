# frozen_string_literal: true

module Roguelike
  class Entity
    attr_accessor :x, :y
    attr_reader :x, :y, :char, :color

    def initialize(x:, y:, char:, color:)
      @x = x
      @y = y
      @char = char
      @color = color
    end

    def move(dx:, dy:)
      @x += dx
      @y += dy
    end
  end
end
