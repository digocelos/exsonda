defmodule Exsonda.Move do
  @moduledoc """
  Módulo responsavel por movimentar as sondas no plataforma (planalto)
  """
  import Exsonda.Helper

  @cardinals_values [
    "N",
    "E",
    "S",
    "W"
  ]

  @doc """
  Passando uma coordenada valida, este método calcula corretamente a posição final
  da sonda no plano

  Exemplo:
  iex> Exsonda.Move.call(coordenadas)
  {:ok,
    %{
      "plataforma" => %{x: 5, y: 5},
      "sondas" => [
        %{"comandos" => "LMLMLMLMM", "dir" => "N", "x" => 1, "y" => 3},
        %{"comandos" => "MMRMMRMRRM", "dir" => "E", "x" => 5, "y" => 1}
      ]
    }}
  """
  def call(%{"plataforma" => plataforma, "sondas" => sondas}) do
    novas_coordenadas_sondas =
      sondas
      |> Enum.map(&executa_comandos(&1, plataforma))

    {:ok, build_coordenadas(plataforma, novas_coordenadas_sondas)}
  end

  defp executa_comandos({:error, reason}, _), do: reason

  defp executa_comandos(sonda, _plataforma) do
    sonda["comandos"]
    |> String.codepoints()
    |> Enum.reduce(sonda, fn movimento, acc -> calcula_posicao(movimento, acc) end)
  end

  defp calcula_posicao(movimento, sonda) do
    case movimento do
      m when m in ["L", "R"] -> gira_sonda(sonda, movimento)
      "M" -> move_sonda(sonda)
    end
  end

  defp move_sonda(sonda) do
    case sonda["dir"] do
      "N" -> update_calc(sonda, "y", 1)
      "S" -> update_calc(sonda, "y", -1)
      "W" -> update_calc(sonda, "x", -1)
      "E" -> update_calc(sonda, "x", 1)
    end
  end

  defp update_calc(sonda, key, fator) do
    Map.update!(sonda, key, fn
      curr when is_binary(curr) -> String.to_integer(curr) + fator
      curr when is_integer(curr) -> curr + fator
    end)
  end

  defp gira_sonda(sonda, direcao) do
    [{_, index}] =
      sonda["dir"]
      |> cardinal_index()

    cond do
      direcao == "L" -> Map.put(sonda, "dir", cardinal_value(index - 1))
      direcao == "R" -> Map.put(sonda, "dir", cardinal_value(index + 1))
    end
  end

  defp cardinal_index(cardinal) do
    @cardinals_values
    |> Enum.with_index()
    |> Enum.filter(fn {card, _index} -> card == cardinal end)
  end

  defp cardinal_value(index) do
    case Enum.fetch(@cardinals_values, index) do
      :error -> cardinal_value(0)
      {:ok, value} -> value
    end
  end
end
