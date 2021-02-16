defmodule BankAccountSubmit do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    # instantiate account with zero balance
    spawn( fn -> account_status(0) end)
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    Process.exit(account, :kill)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    case account_closed(account) do
      :ok -> send(account, {:balance, self()})

      receive do
        {:balance, balance} -> balance
      end

      other -> other
    end
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    case account_closed(account) do
      :ok -> send(account, {:update, amount})
      other -> other
    end
  end

  @doc """
  account_status spawned into existance and listening to receive message
  """
  defp account_status(balance) do
    receive do
      {:balance, teller} ->
        send(teller, {:balance, balance})
        account_status(balance)

      {:update, amount} ->
        account_status(balance + amount)
    end
  end

  @doc """
  Account close state
  """
  defp account_closed(account) do
    case Process.alive?(account) do
      true -> :ok
      _ -> {:error, :account_closed}
    end
  end
end
