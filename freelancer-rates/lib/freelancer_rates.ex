defmodule FreelancerRates do

  @daily_rate 8.0
  @day_in_month 22.0

  def daily_rate(hourly_rate) do
    Float.round(hourly_rate * @daily_rate,1)
  end

  def apply_discount(before_discount, discount) do
    Float.floor(before_discount * (1 - (discount/100)), 2)
  end

  def monthly_rate(hourly_rate, discount) do
    trunc(
      apply_discount( 
        @day_in_month * daily_rate(hourly_rate),
        discount
    )
  )
  end

  def days_in_budget(budget, hourly_rate, discount) do
    budget / monthly_rate(hourly_rate, discount) 
  end
end
