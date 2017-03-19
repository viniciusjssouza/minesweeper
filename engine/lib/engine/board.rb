require 'set'
require 'engine/cell'
require 'forwardable'

module Engine

	# Class which represents the board of the Minesweeper game.
	# The board is composed by several cells.
	# 
	# The board uses an Array of Arrays to represents the grid.
	class Board 	
		
		# Create the board according to the provided 
		# dimensions and number of bombs.
		# The bombs are distributed among the cells 
		# with equal probability of appearing in one of them.
		def initialize(height, width, nBombs)
			raise ArgumentError, 'Invalid board dimensions' if height*width <= 0
			raise ArgumentError, 'Invalid number of bombs' if nBombs < 0 or nBombs >= height*width
		
			@nBombs = nBombs

			bombs = generate_bombs(height, width)

			@matrix = Array.new(height) { |row| 
				Array.new(width) { |col|
					if bombs.include?([row,col]) then 
						Cell.new(row, col, :BOMB)						 
					else  
						Cell.new(row, col, :FREE)
					end 
				} 
			}
			# calculate, for each cell, how many bombs there are in each
			# of its neighbors.
			update_adjacent_bombs()		
		end	
	
		# Returns the cell by its coordinates inside the board.
		def [](i,j)
			@matrix[i][j]
		end

		# Process each cell of the board
		def each_with_index(&block)
			@matrix.each_with_index { |row, i| 
				row.each_with_index { |col, j| block.call(@matrix[i][j], i, j)}
			}			
		end

		# Return all the neighbors of a cell in a given position inside the board.
		def neighbors(row, col)
			a = (-1..1).to_a						
			# produce all combinations of neighbours offset
			a.product(a) \
				# filter the center position
				.select {|x| x != [0,0]} \
				# filter the 'out of bounds' positions
				.select {|i,j| (row+i).between?(0,height-1) && (col+j).between?(0,width-1)}				
				.collect {|i,j| @matrix[row+i][col+j]}
		end


		def	height() 
			@matrix.length
		end

		def	width() 
			@matrix[0].length
		end
		
		def total_bombs()
			@nBombs
		end

		# Return the number of cells inside this board.
		def total_cells()
			width * height				
		end

		# Return the number of cells not containing a bomb.
		def total_cells_without_bombs() 
			total_cells() - total_bombs()
		end

		private
			# Generate random positions to place all the bombs.
			def generate_bombs(height, width)
				positions = Array(0..height-1).shuffle().product(Array(0..width-1).shuffle()).shuffle()
				
				bombs = Set.new()
				@nBombs.times do |i|
					bombs.add(positions[i])
				end	
				return bombs			
			end
		
			# Set the number of adjancent bombs on each cell of the board.
			def	update_adjacent_bombs()
				self.each_with_index { |cell, row, col|
					if cell.has_bomb? then
						self.neighbors(row,col).each { |n| n.add_adjacent_bomb() }											
					end
				}
			end		
	end
end

