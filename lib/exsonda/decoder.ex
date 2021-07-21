defmodule Exsonda.Decoder do
  @moduledoc """
  Módulo responsável por decodificar arquivos parseado e converter em
  um map simples para o processamento de movimentos das sondas.

  Exemplo:
  iex> {:ok, coordenadas} = Exsonda.Decoder.call("arquivo_com_comandos")
  {:ok,
  %{
    "plataforma" => %{x: "5", y: "5"},
    "sondas" => [
      %{"comandos" => "LMLMLMLMM", "dir" => "N", "x" => "1", "y" => "2"},
      %{"comandos" => "MMRMMRMRRM", "dir" => "E", "x" => "3", "y" => "3"}
    ]
  }}
  """
  import Exsonda.Validation

  alias Exsonda.Helper

  def call(stream) do
    result =
      stream
      |> Enum.map(& &1)
      |> decodifica_coordenadas_plataforma()
      |> decodifica_coordenadas_sondas()

    case result do
      {:error, _reason} = e -> e
      coordenadas -> {:ok, coordenadas}
    end
  end

  defp decodifica_coordenadas_plataforma(data) when is_list(data) do
    [coord | sondas] = data

    case valida_coordenadas_plataforma(coord) do
      {:error, reason} ->
        {:error, reason}

      :ok ->
        [x, y] = coord
        Helper.build_coordenadas(%{x: x, y: y}, sondas)
    end
  end

  defp decodifica_coordenadas_sondas(%{"plataforma" => plataforma, "sondas" => sondas}) do
    new_sondas =
      sondas
      |> Enum.chunk_every(2)
      |> Enum.map(&decodifica_sonda(&1))

    Helper.build_coordenadas(plataforma, new_sondas)
  end

  defp decodifica_coordenadas_sondas(error), do: error

  defp decodifica_sonda([[x, y, dir], [comandos]])
       when is_integer(x)
       when is_integer(y)
       when is_bitstring(comandos) do
    case valida_direcao_sonda(dir) do
      {:error, reason} ->
        {:error, reason}

      :ok ->
        comandos
        |> valida_comando()
        |> build_sonda(x, y, dir)
    end
  end

  defp decodifica_sonda(_), do: {:error, "Dados invalidos para esta sonda"}

  defp build_sonda({:ok, comandos}, x, y, dir),
    do: Helper.build_coordenadas_sonda(x, y, dir, comandos)

  defp build_sonda(error, _x, _y, _dir), do: error
end
