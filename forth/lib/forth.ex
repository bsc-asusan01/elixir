defmodule Forth do
  @opaque evaluator :: %Forth{}

  @doc """
  operands attributes invoke known set of operands  function
  """
  @operands %{
    "+" => &__MODULE__.add/1,
    "-" => &__MODULE__.subtract/1,
    "/" => &__MODULE__.divide/1,
    "*" => &__MODULE__.multiply/1,
    "DUP" => &__MODULE__.dup/1,
    "DROP" => &__MODULE__.drop/1,
    "SWAP" => &__MODULE__.swap/1,
    "OVER" => &__MODULE__.over/1
  }


  defstruct stack: [], words: @operands, macros: %{}

  # unicode regex paragraph and control separators
  @separators ~r/[\pC\pZ]+/u

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %Forth{}
  end

  @doc """
  Operands functions
  """
  def add([first, second | tail]), do: [first + second | tail]

  def subtract([first, second | tail]), do: [second - first | tail]

  def divide([0, _ | _t]), do: raise(Forth.DivisionByZero)
  def divide([first, second | tail]), do: [div(second, first) | tail]

  def multiply([first, second | tail]), do: [first * second | tail]

  def dup([]), do: raise(Forth.StackUnderflow)
  def dup([first | tail]), do: [first, first | tail]

  def drop([]), do: raise(Forth.StackUnderflow)
  def drop([_ | tail]), do: tail

  def swap(stack) when length(stack) < 2, do: raise(Forth.StackUnderflow)
  def swap([first, second | tail]), do: [second, first | tail]

  def over(stack) when length(stack) < 2, do: raise(Forth.StackUnderflow)
  def over([first, second | tail]), do: [second, first, second | tail]


  @doc """
  Establishing helper functions for filtering and parsing commands.
  """

  def accept([], ev), do: ev
  def accept([input | rest], %Forth{stack: stack, words: words, macros: macros} = ev) do
    input = String.upcase(input)
    cond do
      macros[input] -> accept(macros[input] ++ rest, ev)
      words[input] -> accept(rest, %Forth{ev | stack: words[input].(stack)})
      is_number?(input) -> accept(rest, %Forth{ev | stack: [String.to_integer(input) | stack]})
      true -> raise Forth.UnknownWord
    end
  end

  def is_number?(num), do: Integer.parse(num) !== :error

  def add_word([word | expansion], ev) do
    cond do
      is_number?(word) -> raise Forth.InvalidWord
      true -> %Forth{ ev | macros: Map.put(ev.macros, String.upcase(word), expansion)}
    end
  end

  def tokenize(command) do
    command
    |> String.split(@separators)
    |> Enum.filter(&(&1 !== ""))
  end

  def exec_command("", ev), do: ev
  def exec_command(command, ev) do
    case tokenize(command) do
      [":" | rest] -> add_word(rest, ev)
      tokens -> accept(tokens, ev)
    end
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    s
    |> String.split(";")
    |> Enum.reduce(ev, &exec_command/2)
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(%Forth{stack: stack}) do
    stack
    |> Enum.reverse
    |> Enum.map_join(" ", &("#{&1}"))
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
