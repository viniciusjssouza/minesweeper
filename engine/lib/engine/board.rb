require 'set'
require 'engine/cell'
require 'forwardable'

module Engine

	class Board 	
		def initialize(height, width, nBombs)
			@nBombs = nBombs

			bombs = generate_bombs(height, width)
			@matrix = Array.new(height) { |row| 
				Array.new(width) { |col|
					if bombs.include?([row,col]) then 
						Cell.new(:BOMB) 
					else  
						Cell.new(:FREE)
					end 
				} 
			}		
		end	

		attr_reader :nBombs

		def [](i,j)
			@matrix[i][j]
		end

		def each_with_index(&block)
			@matrix.each_with_index { |row, i| 
				row.each_with_index { |col, j| block.call(@matrix[i][j], i, j)}
			}			
		end

		def	height() 
			@matrix.length
		end

		def	width() 
			@matrix[0].length
		end

		private
			def generate_bombs(height, width)
				rows,cols = Array(0..@nBombs-1).shuffle(), Array(0..@nBombs-1).shuffle()
				bombs = Set.new()
				@nBombs.times do |i|
					bombs.add([rows[i], cols[i]])
				end	
				return bombs			
			end
	end

	private
	class MutableMatrix < Matrix
		def []=(r, c, val)
			@rows[r][c] = val
		end
	end
end

