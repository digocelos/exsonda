defmodule Exsonda.Validation do
  @moduledoc """
  Módulo com funções para validações de coordenadas de sonda ou validações de comandos
  das sondas.
  """
  alias Exsonda.Helper

  @valid_directions [
    "N",
    "S",
    "E",
    "W"
  ]

  @doc """
  Método utilizado para validação das coordenadas inciais de uma sonda

  Exemplo:

  iex> Exsonda.Validate.valida_coordenadas_plataforma([5, 5])
  :ok

  iex> Exsonda.Validate.validate_coord([5, 5, 4])
  {:error, "Plataforma invalida"}
  """
  def valida_coordenadas_plataforma([x, y] = coord)
      when is_list(coord)
      when tuple_size(coord) == 2
      when is_number(x)
      when is_number(y),
      do: :ok

  def valida_coordenadas_plataforma(_), do: Helper.build_error("Plataforma invalida")

  @doc """
  Método utilizado para validar se os comandos de movimentação de uma determinada sonda,
  é válido ou não

  Exemplo:
  iex> Exsonda.Validation.valida_comando("LLMMRrMl")
  {:ok, "LLMMRrMl"}

  iex> Exsonda.Validation.valida_comando("LLMMRxMl")
  {:error, "Comando invalido (LLMMRxMl)"}
  """
  def valida_comando(comando) do
    case Regex.match?(~r/^[MLR]+$/i, comando) do
      false ->
        Helper.build_error("Comando invalido (#{comando})")

      true ->
        {:ok, comando}
    end
  end

  @doc """
  Método utilizado para validar se a direção inicial de uma sonda é válida

  Exemplo:
  iex> Exsonda.Validation.valida_direcao_sonda("N")
  :ok

  iex> Exsonda.Validation.valida_direcao_sonda("N")
  {:error, "Direcao incial de sonda invalida"}
  """
  def valida_direcao_sonda(direcao) do
    case direcao in @valid_directions do
      true -> :ok
      false -> Helper.build_error("Direcao incial de sonda invalida")
    end
  end
end
