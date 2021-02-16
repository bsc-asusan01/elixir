defmodule BankAccountAgentTest do
  use ExUnit.Case

  setup do
    account = BankAccountAgent.open_bank()
    {:ok, account: account}
  end

  # @tag :pending
  test "initial balance is 0", %{account: account} do
    assert BankAccountAgent.balance(account) == 0
  end

  # @tag :pending
  test "incrementing and checking balance", %{account: account} do
    assert BankAccountAgent.balance(account) == 0
    BankAccountAgent.update(account, 10)
    assert BankAccountAgent.balance(account) == 10
  end

  # @tag :pending
  test "amount is added to balance", %{account: account} do
    assert BankAccountAgent.balance(account) == 0
    BankAccountAgent.update(account, 10)
    BankAccountAgent.update(account, 10)
    assert BankAccountAgent.balance(account) == 20
  end

  # @tag :pending
  test "closing account rejects further inquiries", %{account: account} do
    assert BankAccountAgent.balance(account) == 0
    BankAccount.close_bank(account)
    assert BankAccountAgent.balance(account) == {:error, :account_closed}
    assert BankAccountAgent.update(account, 10) == {:error, :account_closed}
  end

  # @tag :pending
  test "incrementing balance from another process then checking it from test process", %{
    account: account
  } do
    assert BankAccountAgent.balance(account) == 0
    this = self()

    spawn(fn ->
      BankAccountAgent.update(account, 20)
      send(this, :continue)
    end)

    receive do
      :continue -> :ok
    after
      1000 -> flunk("Timeout")
    end

    assert BankAccountAgent.balance(account) == 20
  end

  # @tag :pending
  test "implementation for multiple account support", %{account: account} do
    assert is_pid(account)

    account_two = BankAccountAgent.open_bank()
    assert is_pid(account_two)

    assert account != account_two

    BankAccountAgent.update(account, 20)
    assert BankAccountAgent.balance(account) != BankAccountAgent.balance(account_two)
  end
end
