require_relative '../modules'

MODULES.each do |mod| 
		moduleFolder = File.expand_path("../../#{mod}/lib", __FILE__)
		$LOAD_PATH.unshift(moduleFolder) unless $LOAD_PATH.include?(moduleFolder)	
end
libFolder = File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift(libFolder) unless $LOAD_PATH.include?(libFolder)	
puts "LP: #{$LOAD_PATH}"

require 'printer'
require 'engine/minesweeper'

module MinesweeperApp 
	include Engine, Printer

	def self.main() 
		width, height, num_mines = 10, 10, 25
		game = Minesweeper.new(height, width, num_mines)

		while game.still_playing?
		  row,col = rand(height), rand(width)	
		  puts("Playing on #{row+1},#{col+1}")
		  valid_move = game.play(row,col)

		  row,col = rand(height), rand(width)	
		  puts("Flagging #{row+1},#{col+1}") 	
		  valid_flag = game.flag(row, col)
		
		  if (valid_move or valid_flag) and game.still_playing?
	      	printer = (rand > 0.5) ? SimplePrinter.new : PrettyPrinter.new
			printer.print(game.board_state)
		  end
		end

		puts "Fim do jogo!"
		if game.victory?
		  puts "Você venceu!"
		else
		  puts "Você perdeu! As minas eram:"
		  PrettyPrinter.new.print(game.board_state(xray: true))
		end

		STDOUT.flush
	end

	self.main()
end
