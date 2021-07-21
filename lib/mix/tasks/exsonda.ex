defmodule Mix.Tasks.Exsonda.Init do
  use Mix.Task

  alias Exsonda.{Decoder, Move, Parser}

  def run(file) do
    with {:ok, parsed_file} <- Parser.call(file),
         {:ok, coordenadas} <- Decoder.call(parsed_file),
         {:ok, new_coordenadas} <- Move.call(coordenadas) do
      new_coordenadas["sondas"]
      |> Enum.each(&print_result/1)
    end
  end

  defp print_result(%{"x" => x, "y" => y, "dir" => dir, "comandos" => _com}) do
    IO.puts("#{x} #{y} #{dir}")
  end

  defp print_result(error) do
    IO.puts(error)
  end
end
