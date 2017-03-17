require 'engine/board'
require 'engine/cell'

module Engine

	class Minesweeper
		def initialize(height, width, nBombs)
			@board = Board.new(height, width, nBombs)
		end	

		def play(row, col)
			false
		end

				
		def flag(row, col)
			false
		end

		def still_playing?()
			false
		end

		def victory?()
			false
		end

		def board_state()

		end

	end
end

