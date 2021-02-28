# frozen_string_literal: true

class Entity
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
