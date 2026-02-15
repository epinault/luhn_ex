defmodule LuhnTest do
  use ExUnit.Case, async: true

  doctest Luhn

  describe "valid?/1 with credit card numbers" do
    test "American Express" do
      assert Luhn.valid?("378282246310005")
      assert Luhn.valid?("371449635398431")
    end

    test "American Express Corporate" do
      assert Luhn.valid?("378734493671000")
    end

    test "Australian BankCard" do
      assert Luhn.valid?("5610591081018250")
    end

    test "Diners Club" do
      assert Luhn.valid?("30569309025904")
      assert Luhn.valid?("38520000023237")
    end

    test "Discover" do
      assert Luhn.valid?("6011111111111117")
      assert Luhn.valid?("6011000990139424")
    end

    test "JCB" do
      assert Luhn.valid?("3530111333300000")
      assert Luhn.valid?("3566002020360505")
    end

    test "MasterCard" do
      assert Luhn.valid?("5555555555554444")
      assert Luhn.valid?("5105105105105100")
    end

    test "Visa" do
      assert Luhn.valid?("4111111111111111")
      assert Luhn.valid?("4012888888881881")
      assert Luhn.valid?("4222222222222")
    end
  end

  describe "valid?/1 with integer input" do
    test "accepts integers" do
      assert Luhn.valid?(4111111111111111)
      assert Luhn.valid?(378282246310005)
    end
  end

  describe "valid?/1 with invalid numbers" do
    test "rejects invalid card numbers" do
      refute Luhn.valid?("123456789123456")
      refute Luhn.valid?(123456789123456)
      refute Luhn.valid?("4111111511111112")
    end

    test "single digit zero is valid (checksum 0)" do
      assert Luhn.valid?(0)
      assert Luhn.valid?("0")
    end

    test "raises on non-numeric string" do
      assert_raise ArgumentError, fn ->
        Luhn.valid?("not-a-number")
      end
    end
  end

  describe "valid?/2 with hexadecimal base" do
    test "validates hex numbers" do
      assert Luhn.valid?("abc12392c", 16)
      assert Luhn.valid?("abc1239", 16)
    end

    test "rejects invalid hex numbers" do
      refute Luhn.valid?("abc12392b", 16)
      refute Luhn.valid?("abc123a", 16)
    end
  end

  describe "valid?/2 with invalid base" do
    test "raises with base less than 2" do
      assert_raise FunctionClauseError, fn ->
        Luhn.valid?("123", 1)
      end

      assert_raise FunctionClauseError, fn ->
        Luhn.valid?("123", 0)
      end
    end
  end

  describe "checksum/2" do
    test "returns 0 for valid numbers" do
      assert Luhn.checksum("378282246310005") == 0
    end

    test "returns non-zero for invalid numbers" do
      assert Luhn.checksum("123456789123456") != 0
    end

    test "works with integer input" do
      assert Luhn.checksum(4111111111111111) == 0
    end

    test "works with hex base" do
      assert Luhn.checksum("abc1239", 16) == 0
    end
  end
end
