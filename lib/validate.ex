defmodule Exsonda.Validate do
  alias Exsonda.Util

  def validate_coord({:ok, %{"coord" => [x, y] = coord, "sondas" => sondas}})
      when is_list(coord)
      when tuple_size(coord) == 2
      when is_number(x)
      when is_number(y),
      do: Util.build_return(coord, sondas)

  def validate_coord(_coord), do: {:error, "Invalid coord"}

  def validate_command(command) do
    case Regex.match?(~r/^[MLR]+$/i, command) do
      false -> {:error, "Invalid command (#{command})"}
      true -> {:ok, command}
    end
  end
end
