require 'engine/board'
require 'engine/cell'

module Engine

	#Class which contains the API for playing the Minesweeper game.
	class Minesweeper

		# Creante an instance of the game for a given
		# board dimension and a given number of bombs.	
		def initialize(height, width, nBombs)
			@board = Board.new(height, width, nBombs)
			@visible_cells = 0
			@playing = true
		end	

		# Try to make a move on a given cell
		def play(row, col)
			check_bounds(row,col)			

			if !still_playing?() or @board[row,col].visible? or @board[row,col].flagged? then 
				return false 
			else 
				if @board[row,col].has_bomb? then
					@playing = false
				else
					discover_cell(@board[row,col])
				end				
				return true
			end
		end

		# Try to put a flag on a given cell			
		def flag(row, col)
			check_bounds(row,col)
			
			if !still_playing?() or @board[row,col].visible? then 
				return false 
			else 
				if @board[row,col].has_bomb? then
					@playing = false
				else
					@board[row,col].toggle_flag()
				end				
				return true
			end
		end

		# Check if the game has ended or not
		def still_playing?()
			@playing
		end

		# Check if the user has won the match.
		def victory?()
			!still_playing? && @visible_cells >= @board.total_cells_without_bombs()
		end

		# Symbols used to represent the celss on the board state.
		:FLAG
		:NOT_VISIBLE
		:BOMB

		# Return a representation of the board without revealing the
		# not visible cells.
		def board_state(params = {})
			Array.new(@board.height) { |row| 
				Array.new(@board.width) { |col|
					if @board[row,col].flagged?
						val = :FLAG
					elsif @board[row,col].visible? || (not @playing and params[:xray] = true)
						if @board[row,col].has_bomb?
							val = :BOMB 
	   					else
							val = @board[row,col].bombs_count 							
					   	end
					else 
						val = :NOT_VISIBLE
					end
					val			
				} 
			}
		end

		private
			def discover_cell(cell)

				cell.make_visible()
				@visible_cells += 1
				@playing = false if @visible_cells >= @board.total_cells_without_bombs()

				if cell.bombs_count() == 0 then
					discover_neighbors(cell)	
				end
			end

			def discover_neighbors(cell)
				@board.neighbors(cell.row, cell.col).each { |neighbor| 
					unless neighbor.visible? or neighbor.flagged? then
						neighbor.make_visible()
						discover_cell(neighbor)
					end
				}
					
			end

			def check_bounds(row, col)
				raise ArgumentError, 'Row out of range: #{row}' unless row.between?(0,@board.height-1)
				raise ArgumentError, 'Column out of range: #{col}' unless col.between?(0,@board.width-1)	
			end
	end
end

