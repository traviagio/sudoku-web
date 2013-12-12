require 'sinatra'
require_relative './lib/sudoku'
require_relative './lib/cell'

enable :sessions

def random_sudoku
	seed = (1..9).to_a.shuffle + Array.new(81-9, 0)
	sudoku = Sudoku.new(seed.join)
	sudoku.solve!
	sudoku.to_s.chars
end

def puzzle(sudoku)
	numbers = random_sudoku
	until numbers.count("") == 41
		numbers[rand(0..80)] = ""
	end
	numbers
end


get '/' do
	sudoku = random_sudoku
	session[:solution] = sudoku
	@current_solution = puzzle(sudoku)
	erb :index
end

get '/solution' do
	@current_solution = session[:solution]
	erb :index
end

def box_order_to_row_order(cells)

  boxes = cells.each_slice(9).to_a
  (0..8).to_a.inject([]) {|memo, i|

    first_box_index = i / 3 * 3
    three_boxes = boxes[first_box_index, 3]
    three_rows_of_three = three_boxes.map do |box| 

      row_number_in_a_box = i % 3
      first_cell_in_the_row_index = row_number_in_a_box * 3
      box[first_cell_in_the_row_index, 3]
    end
  
    memo += three_rows_of_three.flatten
  }
end