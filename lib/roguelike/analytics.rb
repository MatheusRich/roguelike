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

      puts "FPS Stats".bold
      puts " · Mean: #{mean(@fps)}"
      puts " · Median: #{median(@fps)}"
      mode(@fps, first: 3).each do |m|
        puts " · Mode: #{m[0]} (#{m[1]} times)"
      end
    end

    private

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
