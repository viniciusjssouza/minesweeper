require "engine/board"
require "test/unit"

class BoardTest < Test::Unit::TestCase
	include Engine

	def test_initialize_noBombs
		#when
		sz = 5
		board = Board.new(sz,sz,0)		

		#expect 
		board.each_with_index do |cell, row, col|
			assert_equal(:FREE, cell.content) 
			assert_equal(0, cell.bombs_count)
		end
	end

	def test_initialize_tenBombs
		#when
		sz = 5
		nBombs = 10
		board = Board.new(sz,sz,nBombs)		
		
		#expect 
		count = 0
		board.each_with_index do |cell, row, col|
			count += 1 if cell.has_bomb?
			assert_equal(count_bombs(board,row,col), cell.bombs_count)								
		end
		assert_equal(nBombs, count)
	end

	def test_count_cells
		board = Board.new(4,2,3)

		assert_equal(8, board.total_cells())
		assert_equal(5, board.total_cells_without_bombs())			
	end

	def test_height_width
		board = Board.new(4,2,0)

		assert_equal(4, board.height())
		assert_equal(2, board.width())			
	end

	def test_brackets()
		#when
		sz = 5
		board = Board.new(sz,sz,0)		

		#expect 
		sz.times { |i|
			sz.times { |j|
				assert(board[i,j].instance_of?(Cell))
			}		
		}
	end

	private
		def count_bombs(board, row, col)
			# produce all combinations of neighbours offset
			a = (-1..1).to_a						
			return a.product(a)
				.select {|i,j| (row+i).between?(0, board.height-1) && (col+j).between?(0, board.width-1)}
				.select {|x| x != [0,0] }
				.select {|i,j| board[row+i,col+j].has_bomb? }				
				.count()
		end
end
