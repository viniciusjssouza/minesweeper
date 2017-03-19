require 'matrix'
require 'forwardable'

module Engine
	
	# Class which represents a single cell inside
	# the board.	
	class Cell

		# Valid cell content informat
		# It may be a free cell or a cell with a bomb
		:FREE
		:BOMB


		# Create a cell with its position inside the board,
		# being initially not visible and without adjacent bombs.
		def initialize(row, col, content = :FREE)
			@content = content
			@row = row
			@col = col
			@flagged = false
			@bombs_count = 0
			@visible = false
		end

		attr_reader :content, :bombs_count, :row, :col

		# Is this cell visible?
		def visible?
			@visible
		end

		# Does this cell contain a flag?
		def flagged?
			@flagged
		end
		
		# Does it contains a bomb or is a free cell?
		def has_bomb?
			@content == :BOMB
		end 
		
		# Inform this cell that one of its neighbors inside the board
		# has a bomb.
		# The limit for adjacent bombs is 8 (a cell has 8 neighbors)
		#
		# Raise an RangeError in case the client tries to add more bombs the allowed.
		def add_adjacent_bomb()
			raise RangeError, 'The maximum number of adjacent bombs are 8' if @bombs_count == 8
			@bombs_count += 1
		end

		# Invert the flag condition. If this cell has a flag, the flag is removed.
		# Otherwise, it put a flag in this cell.
		#
		# Raise an ArgumentError in case the cell is visible (invalid move)
		def toggle_flag()
			raise ArgumentError, 'Only not visible cells can be flagged' if self.visible?
			@flagged = !@flagged
		end
	
		# Set this cell as visible.
		# Raise an ArgumentError in case the cell is flagged (invalid move)
		def make_visible()
			raise ArgumentError, 'Only not flagged cells can be visible' if self.flagged?
			@visible = true
		end
		
		# Return a string representation for this cell.
		def to_s
			"Cell at (#{@row}, #{@col})[visible:#{@visible} content:#{@content} bombs:#{@bombs_count}]"
		end
	end
end

