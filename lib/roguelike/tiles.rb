# frozen_string_literal: true

module Roguelike
  using RichEngine::StringColors

  Graphic = Struct.new(:char, :bg, :fg, keyword_init: true) do
    def to_s
      char.fg(fg).bg(bg)
    end
  end
  Tile = Struct.new(:walkable, :transparent, :dark, keyword_init: true)

  module Tiles
    Floor = Tile.new(walkable: true, transparent: true, dark: Graphic.new(char: "█", bg: :transparent, fg: :black))
    Wall  = Tile.new(walkable: false, transparent: false, dark: Graphic.new(char: "█", bg: :transparent, fg: :white))
  end
end
