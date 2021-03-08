# frozen_string_literal: true

module Roguelike
  using RichEngine::StringColors

  class Graphic
    attr_reader :to_s

    def initialize(char:, bg:, fg:)
      @to_s = char.fg(fg).bg(bg)
    end
  end

  class Tile
    attr_reader :walkable, :transparent, :dark, :light

    def initialize(walkable:, transparent:, dark:, light:)
      @walkable = walkable
      @transparent = transparent
      @dark = dark
      @light = light
    end
  end

  module Tiles
    Floor = Tile.new(
      walkable:    true,
      transparent: true,
      dark:        Graphic.new(char: "█", bg: :transparent, fg: :blue),
      light:       Graphic.new(char: "█", bg: :transparent, fg: :yellow)
    )
    Wall = Tile.new(
      walkable:    false,
      transparent: false,
      dark:        Graphic.new(char: "█", bg: :transparent, fg: :bright_blue),
      light:       Graphic.new(char: "█", bg: :transparent, fg: :bright_yellow)
    )
    Shroud = Tile.new(
      walkable:    false,
      transparent: false,
      dark:        Graphic.new(char: "█", bg: :transparent, fg: :black),
      light:       Graphic.new(char: "█", bg: :transparent, fg: :white)
    )
  end
end
