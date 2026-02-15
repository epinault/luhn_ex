Benchee.run(
  %{
    "Luhn.valid?/1 string (AMEX)" => fn -> Luhn.valid?("378282246310005") end,
    "Luhn.valid?/1 integer (AMEX)" => fn -> Luhn.valid?(378_282_246_310_005) end,
    "Luhn.valid?/1 string (Visa 16-digit)" => fn -> Luhn.valid?("4111111111111111") end,
    "Luhn.valid?/2 hex string" => fn -> Luhn.valid?("abc1239", 16) end,
    "Luhn.checksum/1 string" => fn -> Luhn.checksum("378282246310005") end
  },
  time: 5,
  memory_time: 2,
  formatters: [Benchee.Formatters.Console]
)
