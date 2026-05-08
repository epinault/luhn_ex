defmodule Luhn do
  @moduledoc """
  Validates numbers using the Luhn algorithm (mod 10).

  The Luhn algorithm is a checksum formula used to validate identification
  numbers such as credit card numbers, IMEI numbers, and others.

  Supports arbitrary bases (default base 10).

  ## Examples

      iex> Luhn.valid?("378282246310005")
      true

      iex> Luhn.valid?(4111111111111111)
      true

      iex> Luhn.valid?("abc1239", 16)
      true

      iex> Luhn.valid?("1234567890")
      false
  """

  defguardp valid_base(base) when is_integer(base) and base >= 2

  @doc """
  Checks whether the given number is valid according to the Luhn algorithm.

  Accepts either a string or integer representation of the number.
  An optional `base` parameter can be provided (defaults to 10).

  ## Examples

      iex> Luhn.valid?("378282246310005")
      true

      iex> Luhn.valid?(378282246310005)
      true

      iex> Luhn.valid?(0xABC1239, 16)
      true

      iex> Luhn.valid?("123456789123456")
      false
  """
  @spec valid?(integer() | String.t(), pos_integer()) :: boolean()
  def valid?(number, base \\ 10) when valid_base(base) do
    checksum(number, base) == 0
  end

  @doc """
  Calculates the Luhn checksum for the given number.

  Returns `0` if the number is valid. Accepts strings or integers.

  ## Examples

      iex> Luhn.checksum("378282246310005")
      0

      iex> Luhn.checksum("123456789123456")
      8
  """
  @spec checksum(integer() | String.t(), pos_integer()) :: non_neg_integer()
  def checksum(number, base \\ 10)

  def checksum(number, base) when is_binary(number) and valid_base(base) do
    number
    |> String.to_integer(base)
    |> checksum(base)
  end

  def checksum(number, base) when is_integer(number) and valid_base(base) do
    number
    |> Integer.digits(base)
    |> Enum.reverse()
    |> double(base, 0)
    |> rem(base)
  end

  defp double([], _base, acc), do: acc
  defp double([x], _base, acc), do: x + acc

  defp double([x, y | tail], base, acc) do
    double(tail, base, acc + x + sum(y * 2, base))
  end

  defp sum(number, base) when number >= base, do: number - base + 1
  defp sum(number, _base), do: number
end
