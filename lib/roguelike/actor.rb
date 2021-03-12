# frozen_string_literal: true

require_relative "entity"
require_relative "components/ai"
require_relative "components/fighter"

module Roguelike
  class Actor < Entity
    attr_reader :fighter
    attr_accessor :ai

    def initialize(ai_class:, fighter:, x: 0, y: 0, char: "?", color: :white, name: "<Unnamed>")
      super(x: x, y: y, char: char, color: color, name: name, blocks_movement: true)

      @ai = ai_class.new(entity: self)
      @fighter = fighter
      @fighter.entity = self
    end

    def alive?
      !!@ai
    end
  end
end
