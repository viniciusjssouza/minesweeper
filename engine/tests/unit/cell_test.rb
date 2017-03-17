require "engine/cell"
require "test/unit"

class CellTest < Test::Unit::TestCase
	include Engine

	def test_add_adjacent_bomb
		#given a free cell
		cell = Cell.new(:FREE)

		#when a bomb is placed
		cell.add_adjacent_bomb()	
		cell.add_adjacent_bomb()	

		#expect 
		assert_equal(2, cell.bombs_count) 
	end

	def test_add_illegal_number_of_bombs
		#given a free cell
		cell = Cell.new(:FREE)		

		#add 9 adjacent bombs to raise an error
		assert_raise(RangeError) { 9.times { cell.add_adjacent_bomb() } } 
	end

	def test_toggle_flag
		cell = Cell.new(:BOMB)

		cell.toggle_flag()

		assert_equal(true, cell.flagged?)				
	end

	def test_toogle_flag_many_times

		cell = Cell.new(:BOMB)

		4.times{ cell.toggle_flag() }

		assert_equal(false, cell.flagged?)				
	end

	def test_toogle_flag_invisible_cell
		cell = Cell.new(:BOMB)
		cell.make_visible()
		
		assert_raise(ArgumentError) {cell.toggle_flag}				
	end

	def test_make_visible
		cell = Cell.new(:FREE)
		assert_equal(false, cell.visible?)

		cell.make_visible()

		assert_equal(true, cell.visible?)
	end

	def test_make_visible_flagged_cell
		cell = Cell.new(:FREE)
		cell.toggle_flag()

		assert_raise(ArgumentError) {cell.make_visible()}
	end
end
