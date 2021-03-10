# frozen_string_literal: true

require_relative "entity"

module Roguelike
  Player = Entity.new(char: "@", color: :white, name: "Player", blocks_movement: true)
  Orc    = Entity.new(char: "o", color: :green, name: "Orc", blocks_movement: true)
  Troll  = Entity.new(char: "T", color: :green, name: "Troll", blocks_movement: true)
end
