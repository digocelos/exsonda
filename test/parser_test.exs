defmodule ParserTest do
  use ExUnit.Case

  alias Exsonda.Parser

  describe "call/1" do
    test "when send a valid file, return this" do
      filename = "examples/sonda_ok"

      expected_response = [
        ["5", "5"],
        ["1", "2", "N"],
        ["LMLMLMLMM"],
        ["3", "3", "E"],
        ["MMRMMRMRRM"]
      ]

      assert {:ok, data} = Parser.call(filename)

      response =
        data
        |> Enum.map(& &1)

      assert response == expected_response
    end

    test "when send a invalid file, return an error" do
      filename = "examples/sonda_okx"
      expected_response = "Invalid file"

      assert {:error, reason} = Parser.call(filename)

      assert reason == expected_response
    end
  end
end
