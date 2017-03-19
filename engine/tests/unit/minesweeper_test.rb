require 'rubygems'
require 'test/unit'
require 'mocha/setup'

require 'engine/minesweeper'

class CellTest < Test::Unit::TestCase
	include Engine

	def test_game_start	
		game = Minesweeper.new(6,6,5)
		
		assert(!game.victory?)
		assert(game.still_playing?)  
	end

	###########################################################
	#		TESTS FOR board_state
	###########################################################
	def test_board_state
		game = Minesweeper.new(6,6,5)
		
		invisibleCell = Cell.new(1,1, :FREE)
		flaggedCell = Cell.new(2,2, :FREE)
		flaggedCell.toggle_flag()
		bombCell = Cell.new(3,3, :BOMB)
		visibleCell = Cell.new(4,4,:FREE)
		visibleCell.make_visible()
		visibleCell.expects(:bombs_count).returns(3)
		visibleBombCell = Cell.new(5,5,:BOMB)
		visibleBombCell.make_visible()

		#prepare the mocks
		Board.any_instance.stubs(:[]).with(any_parameters).returns(invisibleCell)
		Board.any_instance.stubs(:[]).with(1,1).returns(invisibleCell)
		Board.any_instance.stubs(:[]).with(2,2).returns(flaggedCell)
		Board.any_instance.stubs(:[]).with(3,3).returns(bombCell)
		Board.any_instance.stubs(:[]).with(4,4).returns(visibleCell)		
		Board.any_instance.stubs(:[]).with(5,5).returns(visibleBombCell)

		state = game.board_state()
	
		assert_equal(:NOT_VISIBLE, state[1][1])
		assert_equal(:FLAG, state[2][2])
		assert_equal(:NOT_VISIBLE, state[3][3])
		assert_equal(3, state[4][4])	
		assert_equal(:BOMB, state[5][5])	
	end	

	###########################################################
	#		TESTS FOR play
	###########################################################
	def test_play_visible_cell
		Cell.any_instance.stubs(:visible?).returns(true)
		game = Minesweeper.new(6,6,5)
		
		valid = game.play(1,1)

		assert(!valid) 
	end

	def test_play_flagged_cell
		Cell.any_instance.stubs(:flagged?).returns(true)
		game = Minesweeper.new(10,10,5)
		
		valid = game.play(2,5)

		assert(!valid) 
	end
	
	def test_play_cell_with_bomb
		cell = Cell.new(2,5,:BOMB)
		Board.any_instance.stubs(:[]).returns(cell)

		game = Minesweeper.new(10,10,5)
		
		valid = game.play(cell.row,cell.col)

		assert(valid) 
		assert(!cell.flagged?)	
		assert(!game.still_playing?())
		assert(!game.victory?())			
	end

	def test_play_free_cells
		freeCell = Cell.new(2,4,:FREE)
		neighbors = [Cell.new(1,4,:FREE),
					 Cell.new(1,3,:FREE),
					 Cell.new(2,3,:FREE),
					 Cell.new(3,3,:FREE),
					 Cell.new(3,4,:FREE),		
					 Cell.new(3,5,:FREE),
					 Cell.new(2,5,:FREE),
					 Cell.new(1,5,:FREE)]

		#prepare the mocks
		neighbors.each{ |n| Board.any_instance.stubs(:[]).with(n.row,n.col).returns(n) }
		Board.any_instance.stubs(:neighbors).with(any_parameters()).returns([])
		Board.any_instance.stubs(:[]).with(freeCell.row,freeCell.col).returns(freeCell)
		Board.any_instance.stubs(:neighbors).with(freeCell.row, freeCell.col).returns(neighbors)
		
		game = Minesweeper.new(6,6,12)
		
		valid = game.play(freeCell.row, freeCell.col)

		assert(valid) 
		assert(freeCell.visible?)
		assert(neighbors.all?{|n| n.visible?})
		assert(game.still_playing?)
		assert(!game.victory?())			
	end	

	def test_play_with_bomb_neighbor
		freeCell = Cell.new(2,4,:FREE)
		neighbors = [Cell.new(1,4,:FREE),
					 Cell.new(1,3,:FREE),
					 Cell.new(2,3,:BOMB),
					 Cell.new(3,3,:FREE),
					 Cell.new(3,4,:FREE),		
					 Cell.new(3,5,:FREE),
					 Cell.new(2,5,:FREE),
					 Cell.new(1,5,:FREE)]
		#prepare the mocks
		Board.any_instance.stubs(:[]).with(freeCell.row,freeCell.col).returns(freeCell)
		freeCell.expects(:bombs_count).returns(1)		

		game = Minesweeper.new(6,6,12)
		
		valid = game.play(freeCell.row, freeCell.col)

		assert(valid) 
		assert(freeCell.visible?)
		assert(neighbors.all?{|n| !n.visible?})
		assert(game.still_playing?)
		assert(!game.victory?())			
	end	

	def test_play_and_win
		#36 cell, 11 bombs -> 25 cell without bombs
		game = Minesweeper.new(6,6,11)

		#avoid bombs	
		Cell.any_instance.stubs(:has_bomb?).returns(false)
		#avoid expansion of cells
		Cell.any_instance.stubs(:bombs_count).returns(1)


		# play on 25 cells without bombs, cheating  :)
		(0..4).to_a.product((0..4).to_a).each{ |row,col|
			assert(!game.victory?)
			assert(game.still_playing?)

			assert(game.play(row, col))			
		}

		assert(game.victory?)
		assert(!game.still_playing?)		
	end		

	def test_play_game_ended
		Minesweeper.any_instance.stubs(:still_playing?).returns(false)
		game = Minesweeper.new(10,10,5)
	
		valid = game.play(2,3)

		assert(!valid)
	end

	def test_play_row_out_of_range
		game = Minesweeper.new(10,10,5)
		assert_raise(ArgumentError) { game.play(10,1)}
	end

	def test_play_col_out_of_range
		game = Minesweeper.new(10,10,5)
		assert_raise(ArgumentError) { game.play(9,-1)}

	end
	
	###########################################################
	#		TESTS FOR flag
	###########################################################
	def test_flag_visible_cell
		Cell.any_instance.stubs(:visible?).returns(true)
		game = Minesweeper.new(10,10,5)
		
		valid = game.flag(1,1)

		assert(!valid) 
	end

	def test_flag_cell
		cell = Cell.new(2,5,:FREE)
		Board.any_instance.stubs(:[]).returns(cell)
		game = Minesweeper.new(10,10,5)
		
		valid = game.flag(cell.row,cell.col)

		assert(valid) 
		assert(cell.flagged?)		
	end

	def test_flag_flagged_cell
		cell = Cell.new(2,5,:FREE)
		cell.toggle_flag()
		Board.any_instance.stubs(:[]).returns(cell)
		game = Minesweeper.new(10,10,5)
		
		valid = game.flag(cell.row,cell.col)

		assert(valid) 
		assert(!cell.flagged?)		
	end

	def test_flag_cell_with_bomb
		cell = Cell.new(2,5,:BOMB)
		Board.any_instance.stubs(:[]).returns(cell)

		game = Minesweeper.new(10,10,5)
		
		valid = game.flag(cell.row,cell.col)

		assert(valid) 
		assert(!cell.flagged?)	
		assert(!game.still_playing?())
		assert(!game.victory?())				
	end

	def test_flag_cell_game_ended
		Minesweeper.any_instance.stubs(:still_playing?).returns(false)
		game = Minesweeper.new(10,10,5)
	
		valid = game.flag(2,3)

		assert(!valid)
	end

	def test_flag_row_out_of_range
		game = Minesweeper.new(10,10,5)
		assert_raise(ArgumentError) { game.play(10,1)}
	end

	def test_flag_col_out_of_range
		game = Minesweeper.new(10,10,5)
		assert_raise(ArgumentError) { game.play(9,-1)}
	end
end


