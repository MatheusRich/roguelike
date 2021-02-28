# frozen_string_literal: true

class Action
end

class EscapeAction < Action
end

class NoAction < Action
end

class MovementAction < Action
  attr_reader :dx, :dy

  def initialize(dx:, dy:)
    # super

    @dx = dx
    @dy = dy
  end
end
