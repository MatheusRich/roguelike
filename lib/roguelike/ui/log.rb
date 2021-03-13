# frozen_string_literal: true

module Roguelike
  module UI
    class Log
      using RichEngine::StringColors
      def initialize
        @messages = []
      end

      def add_message(text, stack: true, fg: :white)
        if stack && !@messages.empty? && same_as_last?(text)
          @messages.last.count += 1
        else
          @messages << Message.new(text, fg: fg)
        end
      end
      alias << add_message

      def render(canvas:, x:, y:, width:, height:)
        y_offset = height - 1

        @messages.reverse.each do |message|
          message.each_slice(width).reverse_each do |line|
            canvas.write_string(line, x: x, y: y + y_offset, fg: message.fg)
            y_offset -= 1

            return if y_offset.negative? # No more space to print messages.
          end
        end
      end

      private

      def same_as_last?(text)
        @messages.last.plain_text == text
      end

      class Message
        using RichEngine::StringColors

        attr_accessor :plain_text, :count
        attr_reader :fg

        def initialize(plain_text, fg:)
          @plain_text = plain_text
          @fg = fg
          @count = 1
        end

        def [](args)
          full_text[args]
        end

        def each_slice(width)
          Enumerator.new do |enumerator|
            full_text.chars.each_slice(width).each do |line|
              fill = [" "] * (line.size - width).abs
              full_line = (line + fill).join

              enumerator.yield(full_line)
            end
          end
        end

        def full_text
          "#{plain_text}#{msg_count}"
        end
        alias to_s full_text

        private

        def msg_count
          " (x#{count})" if @count > 1
        end
      end
    end
  end
end
