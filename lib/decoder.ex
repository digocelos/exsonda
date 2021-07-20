defmodule Exsonda.Decoder do
  @moduledoc """
  Módulo responsável por decodificar arquivos parseado e converter em
  um map simples para o processamento de movimentos das sondas.

  Exemplo:
  iex> {:ok, params} = Exsonda.Parser.call("command_files") |> Exsonda.Decoder.call()
  {:ok,
    %{
      "coord" => ["5", "5"],
      "sondas" => [
        ok: %{"command" => "LMLMLMLMM", "dir" => "N", "x" => "1", "y" => "2"},
        ok: %{"command" => "MMRMMRMRRM", "dir" => "E", "x" => "3", "y" => "3"}
      ]
    }
  }
  """
  import Exsonda.Validate

  alias Exsonda.Helpers.Builder

  # Direções aceitas na posição inicial
  @valid_directions [
    "N",
    "S",
    "E",
    "W"
  ]

  def call({:error, reason}), do: Builder.build_error(reason)

  def call({:ok, stream}) do
    stream
    |> Enum.map(& &1)
    |> decode_coord()
    |> validate_coord()
    |> decode_sondas()
  end

  defp decode_coord(data) when is_list(data) do
    [coord | sondas] = data
    Builder.build_decoder(coord, sondas)
  end

  defp decode_sondas({:ok, %{"coord" => coords, "sondas" => sondas}}) do
    new_sondas =
      sondas
      |> Enum.chunk_every(2)
      |> Enum.map(&decode_sonda(&1))

    Builder.build_decoder(coords, new_sondas)
  end

  defp decode_sondas({:error, reason}), do: Builder.build_error(reason)

  defp decode_sonda([[x, y, dir], [command]])
       when is_integer(x)
       when is_integer(y)
       when dir in @valid_directions
       when is_bitstring(command) do
    command
    |> validate_command()
    |> build_sonda(x, y, dir)
  end

  defp decode_sonda(_), do: Builder.build_error("Invalid sonda coord")

  defp build_sonda({:ok, command}, x, y, dir),
    do: Builder.build_decoder_sonda(x, y, dir, command)

  defp build_sonda({:error, reason}, _x, _y, _dir), do: Builder.build_error(reason)
end
