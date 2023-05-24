defmodule LogParser do
  def valid_line?(line) do
    line =~ ~r/^\[(ERROR|INFO|DEBUG|WARNING)\]/m
  end

  def split_line(line) do
    String.split(line, ~r/<[~*=-]*>/)
  end

  def remove_artifacts(line) do
    String.replace(line, ~r/end-of-line[0-9]+/i, "")
  end

  def tag_with_user_name(line) do
    if line =~ ~r/User\s+/ do
      Regex.named_captures(~r/User\s+(?<username>[^\s]+)/, line)
      |> (&("[USER] " <> &1["username"]<> " " <>line)).()
    else
      line
    end
  end
end
