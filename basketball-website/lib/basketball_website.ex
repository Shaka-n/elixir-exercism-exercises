defmodule BasketballWebsite do
  def extract_from_path(data, path) do
    keys = String.split(path, ".")
      do_extract_from_path(data, keys)
  end

  defp do_extract_from_path(data, []), do: data
  defp do_extract_from_path(data, keys) do
    {key, remaining_keys} = List.pop_at(keys, 0)
    do_extract_from_path(data[key], remaining_keys)
  end

  def get_in_path(data, path) do
    keys = String.split(path, ".")
    get_in(data, keys)
  end
end
