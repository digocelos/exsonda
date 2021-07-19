defmodule Exsonda.Parser do
  def call(filename) do
    case File.exists?(filename) do
      false -> {:error, "Invalid file"}
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
  end
end
