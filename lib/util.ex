defmodule Exsonda.Util do
  @moduledoc """
  Módulo com funções uteis para criação de retornos para coordenadas e sondas
  """

  @doc """
  Método que monta retorno positivo de coordenadas e sondas

  Examplo:
  iex> Exsonda.Util.build_decoder([5, 5], [{}])
  {:ok, %{"coord" => [5, 5], "sondas" => [{}]}}
  """
  def build_decoder(coord, sondas), do: {:ok, %{"coord" => coord, "sondas" => sondas}}

  @doc """
  Método que monta retorno positivo de sonda

  Examplo:
  iex> Exsonda.Util.build_decoder_sonda({"x" => 1, "y" => 1, "dir" => "N"})
  {:ok, %{"x" => 1, "y" => 1, "dir" => "N"}}
  """
  def build_decoder_sonda(x, y, dir, command),
    do: {:ok, %{"x" => x, "y" => y, "dir" => dir, "command" => command}}
end
