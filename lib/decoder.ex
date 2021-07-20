defmodule Exsonda.Decoder do
  @moduledoc """

  """
  import Exsonda.Validate

  alias Exsonda.Util

  @valid_directions [
    "N",
    "S",
    "E",
    "W"
  ]

  def call({:error, reason}), do: {:error, reason}

  def call({:ok, stream}) do
    stream
    |> Enum.map(& &1)
    |> decode_coord()
    |> validate_coord()
    |> decode_sondas()
  end

  defp decode_coord(data) when is_list(data) do
    [coord | sondas] = data
    Util.build_decoder(coord, sondas)
  end

  defp decode_sondas({:ok, %{"coord" => coords, "sondas" => sondas}}) do
    new_sondas =
      sondas
      |> Enum.chunk_every(2)
      |> Enum.map(&decode_sonda(&1))

    Util.build_decoder(coords, new_sondas)
  end

  defp decode_sonda([[x, y, dir], [command]])
       when is_integer(x)
       when is_integer(y)
       when dir in @valid_directions
       when is_bitstring(command) do
    command
    |> validate_command()
    |> build_sonda(x, y, dir)
  end

  defp decode_sonda(_), do: {:error, "Invalid sonda coord"}

  defp build_sonda({:ok, command}, x, y, dir), do: Util.build_decoder_sonda(x, y, dir, command)

  defp build_sonda({:error, reason}, _x, _y, _dir), do: {:error, reason}
end
