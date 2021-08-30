defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    lines_to_print = input
      |> calculate_stats()
      |> get_lines_to_print()

    #lines_to_print = get_lines_to_print(stats)
    """
    Team                           | MP |  W |  D |  L |  P
    #{lines_to_print}
    """
    |> String.trim()
  end

  defp get_lines_to_print(stats) do
    stats
      |> Map.to_list()
      |> Enum.sort_by(fn {_team, %{points: points}} -> points  end, &Kernel.>=/2)
      |> Enum.map(fn {team, stats} ->
        team_string = String.pad_trailing(team, 30)
        matches_string = String.pad_leading("#{stats.matches_played}", 2)
        wins_string = String.pad_leading("#{stats.wins}", 2)
        draws_string = String.pad_leading("#{stats.draws}", 2)
        losses_string = String.pad_leading("#{stats.losses}", 2)
        points_string = String.pad_leading("#{stats.points}", 2)

      "#{team_string} | #{matches_string} | #{wins_string} | #{draws_string} |" <>
        " #{losses_string} | #{points_string}"
      end)
      |> Enum.join("\n")
    end

  defp calculate_stats(input_lines) do
    Enum.reduce(input_lines, %{}, fn line, acc ->
      line
      |> String.split(";")
      |> case do
        [winner, loser, "win"] ->
          acc
          |> update_win(winner)
          |> update_loss(loser)
        [team1, team2, "draw"] ->
          acc
          |> update_draw(team1)
          |> update_draw(team2)
        [loser, winner, "loss"] ->
          acc
          |> update_win(winner)
          |> update_loss(loser)

          _ ->
          acc
      end

    end)

  end
  defp update_win(acc, winner) do
    Map.update(acc, winner, merge_init(%{wins: 1, matches_played: 1, points: 3}), fn stats ->
      stats
      |> Map.update(:wins, 1, fn current_wins -> current_wins + 1 end)
      |> Map.update(:matches_played, 1, fn current_matches_played -> current_matches_played + 1 end)
      |> Map.update(:points, 3, fn current_points -> current_points + 3 end)
    end)
  end

  defp update_loss(acc, loser) do
    Map.update(acc, loser, merge_init(%{losses: 1, matches_played: 1, points: 0}), fn stats ->
      stats
      |> Map.update(:losses, 1, fn current_losses -> current_losses + 1 end)
      |> Map.update(:matches_played, 1, fn current_matches_played -> current_matches_played + 1 end)
    end)
  end
  defp update_draw(acc, team) do
    Map.update(acc, team, merge_init(%{draws: 1, matches_played: 1, points: 1}), fn stats ->
      stats
      |> Map.update(:draws, 1, fn current_draw -> current_draw + 1 end)
      |> Map.update(:matches_played, 1, fn current_matches_played -> current_matches_played + 1 end)
      |> Map.update(:points, 1, fn current_points -> current_points + 1 end)
    end)
  end
  defp merge_init(m) do
    Map.merge(%{wins: 0, losses: 0, draws: 0, matches_played: 0, points: 0}, m)
  end
end
