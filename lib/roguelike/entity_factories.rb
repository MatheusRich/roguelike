# frozen_string_literal: true

require_relative "actor"
require_relative "components/ai"
require_relative "components/fighter"

module Roguelike
  Player = Actor.new(
    char:     "@",
    color:    :white,
    name:     "Player",
    ai_class: Components::HostileEnemy,
    fighter:  Components::Fighter.new(hp: 30, defense: 2, power: 5)
  )
  Orc = Actor.new(
    char:     "o",
    color:    :green,
    name:     "Orc",
    ai_class: Components::HostileEnemy,
    fighter:  Components::Fighter.new(hp: 10, defense: 0, power: 3)
  )
  Troll = Actor.new(
    char:     "T",
    color:    :green,
    name:     "Troll",
    ai_class: Components::HostileEnemy,
    fighter:  Components::Fighter.new(hp: 16, defense: 1, power: 4)
  )
end
