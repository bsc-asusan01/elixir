defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string)
  end

  @def_op [:def, :defp]
  def decode_secret_message_part({op, _, args} = ast, acc) when op in @def_op do
    {fn_name, fn_args} = get_fn_name_and_args(args)

    arity = length(fn_args)
    message = String.slice(to_string(fn_name), 0, arity)

    {ast, [message | acc]}
  end

  def decode_secret_message_part(ast, acc), do: {ast, acc}

  defp get_fn_name_and_args(def_args) do
    case def_args do
      [{:when, _, args} | _] -> get_fn_name_and_args(args)
      [{name, _, args} | _] when is_list(args) -> {name, args}
      [{name, _, args} | _] when is_atom(args) -> {name, []}
    end
  end

  def decode_secret_message(string) do
    ast = to_ast(string)
    {_, acc} = Macro.prewalk(ast, [], &decode_secret_message_part/2)

    acc
    |> Enum.reverse()
    |> Enum.join("")
  end
end
