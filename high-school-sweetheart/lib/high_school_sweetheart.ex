defmodule HighSchoolSweetheart do
  def first_letter(name) do
    name
    |> String.trim()
    |> String.first()
  end

  def initial(name) do
    "#{first_letter(name)}."
    name
    |> first_letter()
    |> String.upcase()
    |> (fn i -> i <> "." end).()
  end

  def initials(full_name) do
    inits =
      full_name
      |> String.split()
      |> Enum.map(&initial/1)

    "#{List.first(inits)}" <> " #{List.last(inits)}"
  end

  def pair(full_name1, full_name2) do
     """
          ******       ******
        **      **   **      **
      **         ** **         **
     **            *            **
     **                         **
     **     #{initials(full_name1)}  +  #{initials(full_name2)}     **
      **                       **
        **                   **
          **               **
            **           **
              **       **
                **   **
                  ***
                   *
     """
  end
end
