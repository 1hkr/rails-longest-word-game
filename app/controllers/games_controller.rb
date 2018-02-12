require 'open-uri'

class GamesController < ApplicationController
  def new
    grid = []
    (1..10).to_a.each do
      grid.push(('A'..'Z').to_a.sample)
    end
    @letters = grid
  end

  def score
    @score = run_game(params[:word], params[:grid], Time.now, Time.now + 1.0)
  end

  def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  api = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
  not_english = { score: 0, message: "not an english word" }
  not_in_the_grid = { score: 0, message: "not in the grid" }
  result = { score: 3, message: "well done" }
  result[:score] = attempt.length - (end_time - start_time)

  return not_in_the_grid if (attempt.upcase.chars & grid.split(' ')) != attempt.upcase.chars
  return not_english if api["found"] == false
  return result
end
end
