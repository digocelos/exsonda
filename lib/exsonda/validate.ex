defmodule Exsonda.Validate do
  @moduledoc """
  Módulo com funções para validações de coordenadas de sonda ou validações de comandos
  das sondas.
  """
  alias Exsonda.Helper

  @doc """
  Método utilizado para validação das coordenadas inciais de uma sonda

  Exemplo:

  iex> Exsonda.Validate.validate_coord({:ok, %{"coord" => [5, 5], "sondas" => [ {} ] }})
  {:ok, %{"coord" => [5, 5], "sondas" => [ {} ]}}

  iex> Exsonda.Validate.validate_coord({:ok, %{"coord" => [5, 5, 4], "sondas" => [ {} ] }})
  {:error, "Invalid coord"}
  """
  def validate_coord({:ok, %{"coord" => [x, y] = coord, "sondas" => sondas}})
      when is_list(coord)
      when tuple_size(coord) == 2
      when is_number(x)
      when is_number(y),
      do: Helper.build_decoder(coord, sondas)

  def validate_coord(_coord), do: Helper.build_error("Invalid coord")

  @doc """
  Método utilizado para validar se os comandos de movimentação de uma determinada sonda,
  é válido ou não

  Exemplo:
  iex> Exsonda.Validate.validate_command("LLMMRrMl")
  {:ok, "LLMMRrMl"}

  iex> Exsonda.Validate.validate_command("LLMMRxMl")
  {:error, "Invalid command (LLMMRxMl)"}
  """
  def validate_command(command) do
    case Regex.match?(~r/^[MLR]+$/i, command) do
      false ->
        Helper.build_error("Invalid command (#{command})")

      true ->
        {:ok, command}
    end
  end
end
