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

    def bresenham_line(x1:, y1:, x2:, y2:)
      dx = x2 - x1
      dy = y2 - y1

      xsign = dx.positive? ? 1 : -1
      ysign = dy.positive? ? 1 : -1

      dx = dx.abs
      dy = dy.abs

      if dx > dy
        xx = xsign
        xy = 0
        yx = 0
        yy = ysign
      else
        dx, dy = dy, dx
        xx = 0
        xy = ysign
        yx = xsign
        yy = 0
      end

      d = 2 * dy - dx
      y = 0

      coords = []

      (0..dx).each do |x|
        x_coord = x1 + x * xx + y * yx
        y_coord = y1 + x * xy + y * yy

        coords << [x_coord, y_coord]

        if d >= 0
          y += 1
          d -= 2 * dx
        end

        d += 2 * dy
      end

      coords
    end

    def distance_between_points(x1:, y1:, x2:, y2:)
      Math.sqrt(((x1 - x2)**2) + ((y1 - y2)**2))
    end

    def chebyshev_distance(x1:, y1:, x2:, y2:)
      dx = (x1 - x2).abs
      dy = (y1 - y2).abs

      [dx, dy].max
    end

    # Adapted from: https://github.com/libtcod/libtcod/blob/develop/src/libtcod/fov_circular_raycasting.c
    def fov(transparent_tiles:, pov:, radius:)
      pov_x, pov_y = pov
      fov_min_x = [pov_x - radius, 0].max.to_i
      fov_min_y = [pov_y - radius, 0].max.to_i

      fov_max_x = [pov_x + radius, transparent_tiles.size].min.to_i
      fov_max_y = [pov_y + radius, transparent_tiles.size].min.to_i
      fov_map = Array.new(transparent_tiles.size) { Array.new(transparent_tiles.first.size) { false } }

      (fov_min_x...fov_max_x).each do |x|
        cast_ray(fov_map, transparent_tiles, pov_x, pov_y, x, fov_min_y, radius)
      end
      (fov_min_y...fov_max_y).each do |y|
        cast_ray(fov_map, transparent_tiles, pov_x, pov_y, fov_max_x, y, radius)
      end
      (fov_max_x).downto(fov_min_x).each do |x|
        cast_ray(fov_map, transparent_tiles, pov_x, pov_y, x, fov_max_y, radius)
      end
      (fov_max_y).downto(fov_min_y).each do |y|
        cast_ray(fov_map, transparent_tiles, pov_x, pov_y, fov_min_x, y, radius)
      end

      fov_map
    end

    def cast_ray(fov, transparency, origin_x, origin_y, dest_x, dest_y, radius)
      bresenham_line(x1: origin_x, y1: origin_y, x2: dest_x, y2: dest_y).each do |current_x, current_y|
        break if distance_between_points(x1: origin_x, y1: origin_y, x2: current_x, y2: current_y) > radius

        blocks_fov = !transparency[current_x][current_y]
        if blocks_fov
          fov[current_x][current_y] = true
          break
        end

        fov[current_x][current_y] = true
      end
    end

    def deep_clone(obj)
      Marshal.load(Marshal.dump(obj))
    end
  end
end
