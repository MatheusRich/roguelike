# frozen_string_literal: true

module Roguelike
  # NOTE: This module will become huge soon. I'll stuff any Math calculation here.
  #       When it became big enough I'll split it in cohesive modules.
  module Calc
    module_function

    def mean(list)
      list.sum / [list.size.to_f, 1.0].max
    end

    def median(list)
      temp = list.sort

      temp[list.size / 2]
    end

    def mode(list, first: nil)
      modes = list.tally.sort_by { |(_, v)| -v }

      first ? modes.first(first) : modes.first
    end

    def variance(list)
      list_mean = mean(list)
      sum_of_squared_differences = list.map { |i| (i - list_mean)**2 }.sum
      sum_of_squared_differences / list.size
    end

    def std_dev(list)
      Math.sqrt(variance(list))
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
