require 'engine/minesweeper'
require 'stringio'

module Printer
	BOARD_FORMAT = {
  		:NOT_VISIBLE => '.',
		:BOMB => '#',
	 	:FLAG => 'F'
	}	

	class SimplePrinter
		include Printer

		def print(board)
			result = StringIO.new
			board.each_with_index { |row, i|
				row.each_with_index { |col, j|
					if board[i][j].is_a? Integer then
						result << board[i][j] << ' '			
					else
						result << BOARD_FORMAT[board[i][j]] << ' '
					end
				}
				result << "\n"
			}
			puts result.string
			puts "\n\n"
		end	
	end

	class PrettyPrinter
		include Printer

		def print(board)
			result = StringIO.new
			board.each_with_index { |row, i|
				result << '|'
				row.each_with_index { |col, j|
					if board[i][j].is_a? Integer 
						result << board[i][j] << '|'			
					else
						result << BOARD_FORMAT[board[i][j]] << '|'
					end
				}
				result << "\n"
				
			}
			puts result.string
			puts "\n\n"
		end	
	end
end
