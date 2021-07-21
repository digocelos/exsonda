defmodule DecoderTest do
  use ExUnit.Case

  alias Exsonda.Decoder
  alias Exsonda.Parser

  setup_all do
    {:ok, file_ok} = Parser.call("examples/sonda_ok")
    {:ok, file_platform_empty_coord} = Parser.call("examples/sonda_platform_empty_coord")
    {:ok, file_platform_invalid_coord} = Parser.call("examples/sonda_platform_invalid_coord")
    {:ok, file_without_start_pos} = Parser.call("examples/sonda_without_start_pos")
    {:ok, file_with_invalid_start_pos} = Parser.call("examples/sonda_with_invalid_start_pos")
    {:ok, file_sonda_without_command} = Parser.call("examples/sonda_without_command")
    {:ok, file_sonda_with_invalid_command} = Parser.call("examples/sonda_with_invalid_command")

    {:ok,
     file_ok: file_ok,
     file_platform_empty_coord: file_platform_empty_coord,
     file_platform_invalid_coord: file_platform_invalid_coord,
     file_without_start_pos: file_without_start_pos,
     file_with_invalid_start_pos: file_with_invalid_start_pos,
     file_sonda_without_command: file_sonda_without_command,
     file_sonda_with_invalid_command: file_sonda_with_invalid_command}
  end

  describe "call/1" do
    test "when send a valid file, return params", state do
      response =
        state.file_ok
        |> Decoder.call()

      expected_response =
        {:ok,
         %{
           "plataforma" => %{x: "5", y: "5"},
           "sondas" => [
             %{
               "comandos" => "LMLMLMLMM",
               "dir" => "N",
               "x" => "1",
               "y" => "2"
             },
             %{
               "comandos" => "MMRMMRMRRM",
               "dir" => "E",
               "x" => "3",
               "y" => "3"
             }
           ]
         }}

      assert expected_response == response
    end

    test "when send a file with empty platform coord, return error", state do
      assert {:error, response} =
               state.file_platform_empty_coord
               |> Decoder.call()

      expected_response = "Plataforma invalida"

      assert expected_response == response
    end

    test "when send a file with invalid platform coord, return error", state do
      assert {:error, response} =
               state.file_platform_invalid_coord
               |> Decoder.call()

      expected_response = "Plataforma invalida"

      assert expected_response == response
    end

    test "when send a file without sonda start position, return a sonda comand error", state do
      assert {:ok, response} =
               state.file_without_start_pos
               |> Decoder.call()

      expected_response = %{
        "plataforma" => %{x: "5", y: "5"},
        "sondas" => [
          {:error, "Dados invalidos para esta sonda"},
          %{
            "comandos" => "MMRMMRMRRM",
            "dir" => "E",
            "x" => "3",
            "y" => "3"
          }
        ]
      }

      assert expected_response == response
    end

    test "when send a file with invalid sonda start position, return a sonda comand error",
         state do
      assert {:ok, response} =
               state.file_with_invalid_start_pos
               |> Decoder.call()

      expected_response = %{
        "plataforma" => %{x: "5", y: "5"},
        "sondas" => [
          {:error, "Direcao incial de sonda invalida"},
          %{
            "comandos" => "MMRMMRMRRM",
            "dir" => "E",
            "x" => "3",
            "y" => "3"
          }
        ]
      }

      assert expected_response == response
    end

    test "when send a file without sonda command, return a sonda comand error", state do
      assert {:ok, response} =
               state.file_sonda_without_command
               |> Decoder.call()

      expected_response = %{
        "plataforma" => %{x: "5", y: "5"},
        "sondas" => [
          error: "Dados invalidos para esta sonda",
          error: "Dados invalidos para esta sonda"
        ]
      }

      assert expected_response == response
    end

    test "when send a file with invalid sonda command, return a sonda comand error", state do
      assert {:ok, response} =
               state.file_sonda_with_invalid_command
               |> Decoder.call()

      expected_response = %{
        "plataforma" => %{x: "5", y: "5"},
        "sondas" => [
          {:error, "Comando invalido (LMLMLMHMM)"},
          %{
            "comandos" => "MMRMMRMRRM",
            "dir" => "E",
            "x" => "3",
            "y" => "3"
          }
        ]
      }

      assert expected_response == response
    end
  end
end
