# frozen_string_literal: true

module Roguelike
  using RichEngine::StringColors

  class Analytics
    def initialize
      @fps = []
    end

    def track_fps(dt)
      @fps << (1 / dt).round(8)
    end

    def display_fps_stats
      @fps.shift

      puts "FPS STATS".bold.underline
      puts info("Mean", mean(@fps))
      puts info("Median", median(@fps))
      mode(@fps, first: 3).each_with_index do |m, i|
        puts info("Mode (top #{i + 1})", "#{m[0]} (#{m[1]} times)")
      end
    end

    private

    def info(label, value)
      flabel = label.bold
      " · #{flabel}: #{value}"
    end

    def mean(array)
      array.sum / [array.size, 1].max
    end

    def median(array)
      temp = array.sort

      temp[array.size / 2]
    end

    def mode(array, first: 1)
      rounded = array.map(&:round)

      rounded.tally.sort_by { |(_, v)| -v }.first(first)
    end
  end
end
