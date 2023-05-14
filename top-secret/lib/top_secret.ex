defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string) 
  end

  def decode_secret_message_part(ast, acc) do
    updated_acc = 
      case ast do
        {:def, _, top_args} ->
          sliced_name = do_decode(top_args) 
           [sliced_name | acc]

        {:defp, _, top_args} ->
          sliced_name = do_decode(top_args)
           [sliced_name | acc]

        _ ->
          acc
          
      end
    {ast, updated_acc}
  end

  defp do_decode(top_args) do
    {name, _, fn_args} = List.first(top_args) 
    cond do
      fn_args == nil -> 
      ""
      name == :when ->
        do_decode(fn_args)
      true ->
      arity = length(fn_args)
        name
        |> Atom.to_string()
        |> String.slice(0, arity)
    end

  end

  def decode_secret_message(string) do
    {_, acc} =
    string
    |> to_ast()
    |> Macro.prewalk([], &decode_secret_message_part/2)

    acc
    |> Enum.reverse()
    |> List.to_string()
    
  end
end
