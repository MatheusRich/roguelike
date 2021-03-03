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
    Floor = Tile.new(walkable: true, transparent: true, dark: Graphic.new(char: "█", bg: :transparent, fg: :black))
    Wall  = Tile.new(walkable: false, transparent: false, dark: Graphic.new(char: "█", bg: :transparent, fg: :white))
  end
end
