# frozen_string_literal: true

module Roguelike
  module Calc
    module_function

    def mean(array)
      array.sum / [array.size, 1].max
    end

    def median(array)
      temp = array.sort

      temp[array.size / 2]
    end

    def mode(array, first: nil)
      modes = array.tally.sort_by { |(_, v)| -v }

      first ? modes.first(first) : modes.first
    end

    # Src: https://www.geeksforgeeks.org/bresenhams-line-generation-algorithm/
    def bresenham(x1:, y1:, x2:, y2:)
      Enumerator.new do |enumerator|
        m_new = 2 * (y2 - y1)
        slope_error_new = m_new - (x2 - x1)

        y = y1

        (x1..x2).each do |x|
          enumerator.yield([x, y])

          # Add slope to increment angle formed
          slope_error_new += m_new

          # Slope error reached limit, time to
          # increment y and update slope error.
          if slope_error_new >= 0
            y += 1
            slope_error_new -= 2 * (x2 - x1)
          end
        end
      end
    end
  end
end
