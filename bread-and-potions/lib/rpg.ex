defmodule RPG do
  defmodule Character do
    defstruct health: 100, mana: 0
  end

  defmodule LoafOfBread do
    defstruct []
  end

  defmodule ManaPotion do
    defstruct strength: 10
  end

  defmodule Poison do
    defstruct []
  end

  defmodule EmptyBottle do
    defstruct []
  end

  defprotocol Edible do
    def eat(itme, char)
  end

  defimpl Edible, for: LoafOfBread do
    def eat(_item, char) do
      {nil, %{char | health: char.health + 5}}
    end
  end

  defimpl Edible, for: ManaPotion do
    def eat(item, char) do
      {%EmptyBottle{}, %{char | mana: char.mana + item.strength}}
      end
  end

  defimpl Edible, for: Poison do
    def eat(_item, char) do
      {%EmptyBottle{}, %{char | health: 0}}
    end
  end
end
