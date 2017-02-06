require 'termnote/pane/helpers'
require 'termnote/pane/chapter'
require 'termnote/pane/text'
require 'termnote/pane/code'
require 'termnote/pane/console'

module TermNote
  module Pane
    attr_accessor :show, :height, :width, :rows

    def call(window_size)
      window_height, window_width = window_size
      @width = window_width
      @height = window_height
      clear
      render
    end

    private

    def clear
      system("clear")
    end

    def render
      puts show.header + space + formatted_rows + space(true)
    end

    def space(final=false)
      rows_length = formatted_rows.lines.count
      space_length = (height - rows_length)
      newlines = height > rows_length ? space_length / 2 : 0
      if !final && space_length.even?
        newlines -= 1
      end
      "\n" * newlines
    end

    def formatted_rows
      @output ||= rows.map(&method(:guttered_row)).join("\n")
    end

    def guttered_row(row)
      raise ArgumentError, "content was larger than screen" if gutter_width(row) < 0
      gutter(row) + row
    end

    def gutter(row)
      " " * gutter_width(row)
    end

    def gutter_width(row)
      (width / 2.0).floor - (row.width / 2.0).ceil
    end
  end
end
