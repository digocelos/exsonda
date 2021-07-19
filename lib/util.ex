defmodule Exsonda.Util do
  def build_return(coord, sondas), do: {:ok, %{"coord" => coord, "sondas" => sondas}}
end
