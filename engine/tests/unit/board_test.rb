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
		end
	end

	def test_initialize_fiveBombs
		#when
		sz = 5
		nBombs = 5
		board = Board.new(sz,sz,nBombs)		
		
		#expect 
		count = 0
		board.each_with_index do |cell, row, col|
			count += 1 if cell.has_bomb?
		end
		assert_equal(nBombs, count)
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
end
