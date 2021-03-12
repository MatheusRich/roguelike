# frozen_string_literal: true

module Roguelike
  module Components
    module BaseComponent
      attr_accessor :entity

      def engine
        @entity.game_map.engine
      end
    end
  end
end
