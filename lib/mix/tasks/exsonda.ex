defmodule Mix.Tasks.Exsonda.Run do
  use Mix.Task

  alias Exsonda.Parser
  alias Exsonda.Decoder
  alias Exsonda.Process

  def run(file) do
    IO.puts("processando #{file}")
  end
end
