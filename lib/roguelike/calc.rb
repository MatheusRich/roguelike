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

    # Src: https://github.com/seandmccarthy/bresenham/blob/master/lib/bresenham/line.rb
    def bresenham_line(x1:, y1:, x2:, y2:)
      dx     = (x2 - x1).abs
      dy     = -(y2 - y1).abs
      step_x = x1 < x2 ? 1 : -1
      step_y = y1 < y2 ? 1 : -1
      err    = dx + dy

      coords = Set.new [[x1, y1]]
      begin
        e2 = 2 * err
        if e2 >= dy
          err += dy
          x1 += step_x
        end
        if e2 <= dx
          err += dx
          y1 += step_y
        end
        coords << [x1, y1]
      end until (x1 == x2 && y1 == y2)

      coords
    end

    def distance_between_points(x1:, y1:, x2:, y2:)
      Math.sqrt(((x1 - x2)**2) + ((y1 - y2)**2))
    end
  end
end
