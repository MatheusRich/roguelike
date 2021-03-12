# frozen_string_literal: true

module Roguelike
  module Log
    extend self

    $logs = []

    def call(msg)
      $logs << msg
    end

    def get
      puts $logs.first(5).join("\n")

      $logs.clear
    end
  end
end
