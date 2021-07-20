defmodule ValidateTest do
  use ExUnit.Case

  alias Exsonda.Validate

  describe "validate_coord/1" do
    test "when send a valid coord, return ok" do
      valid_coord = {:ok, %{"coord" => [5, 6], "sondas" => []}}
      expected_value = %{"coord" => [5, 6], "sondas" => []}

      assert {:ok, response} = Validate.validate_coord(valid_coord)

      assert response == expected_value
    end

    test "when send a invalid coord, return error" do
      invalid_coord = {:ok, %{"coord" => [5, 6, 7], "sondas" => []}}
      expected_value = "Invalid coord"

      assert {:error, response} = Validate.validate_coord(invalid_coord)

      assert response == expected_value
    end
  end
end
