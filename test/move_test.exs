defmodule MoveTest do
  use ExUnit.Case

  alias Exsonda.Move

  describe "call/1" do
    test "when send a valid coord, return ok" do
      coordenadas = %{
        "plataforma" => %{x: "5", y: "5"},
        "sondas" => [
          %{"comandos" => "LMLMLMLMM", "dir" => "N", "x" => "1", "y" => "2"},
          %{"comandos" => "MMRMMRMRRM", "dir" => "E", "x" => "3", "y" => "3"}
        ]
      }

      expected_response =
        {:ok,
         %{
           "plataforma" => %{x: "5", y: "5"},
           "sondas" => [
             %{"comandos" => "LMLMLMLMM", "dir" => "N", "x" => 1, "y" => 3},
             %{"comandos" => "MMRMMRMRRM", "dir" => "E", "x" => 5, "y" => 1}
           ]
         }}

      response = Move.call(coordenadas)

      assert response == expected_response
    end

    test "when send a invalid sonda positions, calc only the corrects" do
      coordenadas = %{
        "plataforma" => %{x: 5, y: 5},
        "sondas" => [
          %{"x" => 1, "y" => 2, "dir" => "N", "comandos" => "LMLMLMLMM"},
          {:error, "Alguma coisa"}
        ]
      }

      expected_response =
        {:ok,
         %{
           "plataforma" => %{x: 5, y: 5},
           "sondas" => [
             %{"comandos" => "LMLMLMLMM", "dir" => "N", "x" => 1, "y" => 3},
             "Alguma coisa"
           ]
         }}

      response = Move.call(coordenadas)

      assert response == expected_response
    end
  end
end
