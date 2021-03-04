# frozen_string_literal: true

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
end
