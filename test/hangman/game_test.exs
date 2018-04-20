defmodule Hangman.GameTest do
  use ExUnit.Case
  doctest Hangman.Game

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    Enum.map(game.letters, fn (letter) -> (assert letter in (for n <- ?a..?z, do: << n :: utf8 >>)) end)
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert ^game= Game.make_move(game, "x")
    end
  end

  test "first occurance of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurance of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guesses word is a won game" do
    moves = [
      {"w", :good_guess},
      {"i", :good_guess},
      {"b", :good_guess},
      {"l", :good_guess},
      {"e", :won}
    ]

    game = Game.new_game("wibble")

    Enum.reduce(
      moves,
      game,
      fn (_move = { guess, state }, game) ->
          new_game = Game.make_move(game, guess)
          assert new_game.game_state == state
          assert new_game.turns_left == game.turns_left
          new_game
      end
    )
  end

  test "bad guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost game is recognized" do

    moves = [
      {"a", :bad_guess},
      {"b", :bad_guess},
      {"c", :bad_guess},
      {"d", :bad_guess},
      {"e", :bad_guess},
      {"f", :bad_guess},
      {"g", :lost}
    ]

    game = Game.new_game("w")


    Enum.reduce(
      moves,
      game,
      fn (_move = { guess, state }, game) ->
        new_game = Game.make_move(game, guess)
        assert new_game.game_state == state
        assert new_game.turns_left == game.turns_left - 1
        new_game
      end
    )
  end
end