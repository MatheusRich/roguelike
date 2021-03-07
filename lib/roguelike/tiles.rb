# frozen_string_literal: true

module Roguelike
  using RichEngine::StringColors

  class Graphic
    attr_reader :to_s

    def initialize(char:, bg:, fg:)
      @to_s = char.fg(fg).bg(bg)
    end
  end

  Tile = Struct.new(:walkable, :transparent, :dark, keyword_init: true)

  module Tiles
    Fire  = Tile.new(walkable: true, transparent: true, dark: Graphic.new(char: "█", bg: :transparent, fg: :red))
    Ice   = Tile.new(walkable: true, transparent: true, dark: Graphic.new(char: "█", bg: :transparent, fg: :blue))
    Floor = Tile.new(walkable: true, transparent: true, dark: Graphic.new(char: "█", bg: :transparent, fg: :black))
    Wall  = Tile.new(walkable: false, transparent: false, dark: Graphic.new(char: "█", bg: :transparent, fg: :blue))
  end
end
