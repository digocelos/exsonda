defmodule DecoderTest do
  use ExUnit.Case

  alias Exsonda.Decoder
  alias Exsonda.Parser

  setup_all do
    valid_file = Parser.call("examples/sonda_ok")
    file_without_coord = Parser.call("examples/sonda_without_coord")
    file_with_invalid_coord = Parser.call("examples/sonda_with_invalid_coord")
    file_without_start_pos = Parser.call("examples/sonda_without_start_pos")
    file_sonda_without_command = Parser.call("examples/sonda_without_command")
    file_sonda_with_invalid_command = Parser.call("examples/sonda_with_invalid_command")

    {:ok,
     valid_file: valid_file,
     file_without_coord: file_without_coord,
     file_with_invalid_coord: file_with_invalid_coord,
     file_without_start_pos: file_without_start_pos,
     file_sonda_without_command: file_sonda_without_command,
     file_sonda_with_invalid_command: file_sonda_with_invalid_command}
  end

  describe "call/1" do
    test "when send a valid file, return params", state do
      response =
        state.valid_file
        |> Decoder.call()

      expected_response =
        {:ok,
         %{
           "coord" => ["5", "5"],
           "sondas" => [
             ok: %{
               "command" => "LMLMLMLMM",
               "dir" => "N",
               "x" => "1",
               "y" => "2"
             },
             ok: %{
               "command" => "MMRMMRMRRM",
               "dir" => "E",
               "x" => "3",
               "y" => "3"
             }
           ]
         }}

      assert expected_response == response
    end

    test "when send a file without coord, return error", state do
      assert {:error, response} =
               state.file_without_coord
               |> Decoder.call()

      expected_response = "Invalid coord"

      assert expected_response == response
    end

    test "when send a file with invalid coord, return error", state do
      assert {:error, response} =
               state.file_with_invalid_coord
               |> Decoder.call()

      expected_response = "Invalid coord"

      assert expected_response == response
    end

    test "when send a file without sonda start position, return a sonda comand error", state do
      assert {:ok, response} =
               state.file_without_start_pos
               |> Decoder.call()

      expected_response = %{
        "coord" => ["5", "5"],
        "sondas" => [
          error: "Invalid sonda coord",
          ok: %{
            "command" => "MMRMMRMRRM",
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
        "coord" => ["5", "5"],
        "sondas" => [
          error: "Invalid sonda coord",
          error: "Invalid sonda coord"
        ]
      }

      assert expected_response == response
    end

    test "when send a file with invalid sonda command, return a sonda comand error", state do
      assert {:ok, response} =
               state.file_sonda_with_invalid_command
               |> Decoder.call()

      expected_response = %{
        "coord" => ["5", "5"],
        "sondas" => [
          error: "Invalid command (LMLMLMHMM)",
          ok: %{
            "command" => "MMRMMRMRRM",
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
