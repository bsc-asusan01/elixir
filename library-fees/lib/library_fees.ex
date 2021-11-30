defmodule LibraryFees do
  def datetime_from_string(string), do:
    NaiveDateTime.from_iso8601!(string)

  def before_noon?(datetime), do:
    datetime.hour < 12

  def return_date(checkout_datetime) do
    date = checkout_datetime
      |> NaiveDateTime.to_date

    if before_noon?(checkout_datetime) do
      date |> Date.add(28)
    else
      date |> Date.add(29)
    end
  end

  def days_late(planned_return_date, actual_return_datetime) do
    days_diff =
      Date.diff(actual_return_datetime, planned_return_date)

    if days_diff > 0 do
      days_diff
    else
      0
    end
  end

  def monday?(datetime), do: Date.day_of_week(datetime) == 1

  def calculate_late_fee(checkout, return, rate) do
    checkout_datetime = datetime_from_string(checkout)
    return_datetime = datetime_from_string(return)
    expected_due_date = return_date(checkout_datetime)
    computed_rate = if monday?(return_datetime) do rate * 0.5 else rate end

    days_late(expected_due_date, return_datetime) * computed_rate
    |> trunc

  end
end
