require 'matrix'
require 'forwardable'

module Engine
	
	class Cell
		:FREE
		:BOMB

		def initialize(content = :FREE)
			@content = content
			@flagged = false
			@bombs_count = 0
			@visible = false
		end

		attr_reader :content, :bombs_count

		def visible?
			@visible
		end

		def flagged?
			@flagged
		end

		def has_bomb?
			@content == :BOMB
		end 
		
		def add_adjacent_bomb()
			raise RangeError, 'The maximum number of adjacent bombs are 8' if @bombs_count == 8
			@bombs_count += 1
		end

		def toggle_flag()
			raise ArgumentError, 'Only not visible cells can be flagged' if self.visible?
			@flagged = !@flagged
		end

		def make_visible()
			raise ArgumentError, 'Only not flagged cells can be visible' if self.flagged?
			@visible = true
		end
	end
end

