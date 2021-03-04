# frozen_string_literal: true

module Roguelike
  module Graphics
    class UL
      def initialize
        @buffer = ""
        @spacing = 0
      end

      def self.build(&block)
        ul = new
        ul.instance_exec(&block)

        ul
      end

      def to_s
        @buffer
      end

      def li(text, marker: "·")
        @buffer += indentation
        @buffer += marker.nil? ? "" : "#{marker} "
        @buffer += text
        @buffer += "\n"

        return unless block_given?

        @spacing += 2
        yield
        @spacing -= 2
      end

      private

      def indentation
        " " * @spacing
      end
    end
  end
end
