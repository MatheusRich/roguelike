# frozen_string_literal: true

require_relative "calc"
require_relative "graphics/ul"

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

      fps_mean = "Mean: ".bold + Calc.mean(@fps).to_s
      fps_median = "Median: ".bold + Calc.median(@fps).to_s
      mode = Calc.mode(@fps.map(&:round))
      fps_mode = "Mode: ".bold + "#{mode[0]} (#{mode[1]} times)"
      fps_std_dev = "Std dev: ".bold + Calc.std_dev(@fps).to_s
      max_min = "Min/Max: ".bold + @fps.minmax.join(" / ")

      ul = Graphics::UL.build do
        li("FPS STATS".bold.underline, marker: nil) do
          li(fps_mean)
          li(fps_median)
          li(fps_mode)
          li(fps_std_dev)
          li(max_min)
        end
      end

      puts ul
    end
  end
end
