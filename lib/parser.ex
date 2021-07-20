defmodule Exsonda.Parser do
  @moduledoc """
  Módulo responsável por efetuar a leitura e validação inicial do arquivo

  Exemplos:
  iex> Exsonda.Parser.call(filename)
  {:ok, stream}

  iex> Exsonda.Parser.call(arquivo_inexistente)
  {:error, "Invalid file"}
  """

  alias Exsonda.Helpers.Builder

  @doc """
  Função de chamada para efetuar a leitura do arquivo com os dados de sondas
  """
  def call(filename) do
    case File.exists?(filename) do
      false -> Builder.build_error("Invalid file")
      true -> parser_file(filename)
    end
  end

  defp parser_file(filename) do
    {:ok,
     filename
     |> File.stream!()
     |> Stream.map(&parser_line/1)}
  end

  defp parser_line(line) do
    line
    |> String.trim()
    |> String.split(" ")
  end
end
