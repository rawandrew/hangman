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
end