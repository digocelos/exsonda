defmodule Exsonda.Helper do
  @moduledoc """
  Módulo com funções uteis para criação de retornos para coordenadas e sondas
  """

  def build_coordenadas(plataforma, sondas), do: %{"plataforma" => plataforma, "sondas" => sondas}

  def build_coordenadas_sonda(x, y, dir, comandos),
    do: %{"x" => x, "y" => y, "dir" => dir, "comandos" => comandos}

  @doc """
  Método que monta retorno positivo de coordenadas e sondas

  Examplo:
  iex> Exsonda.Util.build_decoder([5, 5], [{}])
  {:ok, %{"coord" => [5, 5], "sondas" => [{}]}}
  """
  def build_decoder(coord, sondas), do: {:ok, %{"plataforma" => coord, "sondas" => sondas}}

  @doc """
  Método que monta retorno positivo de sonda

  Examplo:
  iex> Exsonda.Util.build_decoder_sonda({"x" => 1, "y" => 1, "dir" => "N"})
  {:ok, %{"x" => 1, "y" => 1, "dir" => "N"}}
  """
  def build_decoder_sonda(x, y, dir, command),
    do: {:ok, %{"x" => x, "y" => y, "dir" => dir, "command" => command}}

  @doc """
  Mótodo construtor de erro padrão

  Exemplo:
  iex>Exsonda.Helpers.Builder.build_error("teste")
  {:error, "teste"}
  """
  def build_error(reason), do: {:error, reason}
end
