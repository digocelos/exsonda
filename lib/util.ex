defmodule Exsonda.Util do
  def build_decoder(coord, sondas), do: {:ok, %{"coord" => coord, "sondas" => sondas}}

  def build_decoder_sonda(x, y, dir, command),
    do: {:ok, %{"x" => x, "y" => y, "dir" => dir, "command" => command}}
end
