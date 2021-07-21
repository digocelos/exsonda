defmodule ValidationTest do
  use ExUnit.Case

  alias Exsonda.Validation

  describe "valida_coordenadas_plataforma/1" do
    test "when send a valid coord, return ok" do
      expected_value = :ok
      response = Validation.valida_coordenadas_plataforma([5, 6])

      assert response == expected_value
    end

    test "when send a invalid coord, return error" do
      expected_value = {:error, "Plataforma invalida"}

      response = Validation.valida_coordenadas_plataforma([5, 6, 7])

      assert response == expected_value
    end

    test "when send a empty coord, return error" do
      expected_value = {:error, "Plataforma invalida"}

      response = Validation.valida_coordenadas_plataforma([])

      assert response == expected_value
    end
  end

  describe "valida_comando/1" do
    test "when send a valid command, return ok" do
      expected_response = {:ok, "LMMRMM"}
      response = Validation.valida_comando("LMMRMM")

      assert response == expected_response
    end

    test "when send a invalid command, return error" do
      expected_response = {:error, "Comando invalido (LMMRxMM)"}
      response = Validation.valida_comando("LMMRxMM")

      assert response == expected_response
    end
  end

  describe "valida_direcao_sonda/1" do
    test "when send a valid cardinal position, return ok" do
      expected_response = :ok
      response = Validation.valida_direcao_sonda("S")

      assert response == expected_response
    end

    test "when send a invalid cardinal position, return erro" do
      expected_response = {:error, "Direcao incial de sonda invalida"}
      response = Validation.valida_direcao_sonda("H")

      assert response == expected_response
    end
  end
end
