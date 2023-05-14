defmodule Username do
  def sanitize(username) do
    
    username
    |> Enum.map(fn ch ->
      case ch do
        ?ä ->
          [?a, ?e] 
        ?ö ->
          [?o, ?e]
        ?ü ->
          [?u, ?e]
        ?ß ->
        [?s, ?s]
        _->
         ch
      end
    end)
    |> List.flatten()
    |> Enum.filter(fn ch -> (ch >=?a && ch <=?z) || ch == ?_ end)
  end
end
