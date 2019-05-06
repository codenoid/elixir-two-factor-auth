defmodule Elixir2fa do
  @moduledoc """
  Documentation for Elixir2fa.
  """

  @doc """
  Elixir Two Factor Authenticator.

  ## Examples

      iex> secret = Elixir2fa.random_secret(16)     
      "HpJBFRtHjgIQJWIB"
      iex> Elixir2fa.generate_qr("account_name", secret)
      "https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=200x200&chld=M|0&cht=qr&chl=otpauth://totp/account_name?secret=HpJBFRtHjgIQJWIB"
      iex> Elixir2fa.generate_totp(secret)              
      "573671"

  """

  @doc """
  Return the QR image url thanks to Google. This can be shown to the user and scanned by the authenticator program
  as an easy way to enter the secret.
  * name: Name of the key that you want to show up in the users authentication application. Should already be URL encoded.
  * secret: Secret string that will be used when generating the current number.
  """
  def generate_qr(name, secret) do
    otp_url = otp_auth_url(name, secret)
    "https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=200x200&chld=M|0&cht=qr&chl=#{otp_url}"
  end

  @doc """
  Return the otp-auth part of the QR image which is suitable to be injected into other QR generators (e.g. JS generator)
  * name: Name of the key that you want to show up in the users authentication application. Should already be URL encoded.
  * secret: Secret string that will be used when generating the current number.
  """
  defp otp_auth_url(name, secret) do
    "otpauth://totp/#{name}?secret=#{secret}"
  end

  defp generate_hmac(secret, period) do
    # Clean unwanted character from the secret and decode it using Base32 "encoding"
    key = secret
          |> String.replace(" ", "")
          |> String.upcase
          |> Base.decode32!

    # Generate the moving mactor
    moving_factor = DateTime.utc_now
                    |> DateTime.to_unix
                    |> Integer.floor_div(period)
                    |> Integer.to_string(16)
                    |> String.pad_leading(16, "0")
                    |> String.upcase
                    |> Base.decode16!

    # Generate SHA-1
    :crypto.hmac(:sha, key, moving_factor)
  end

  defp hmac_dynamic_truncation(hmac) do
    # Get the offset from last  4-bits
    <<_::19-binary, _::4, offset::4>> = hmac

    # Get the 4-bytes starting from the offset
    <<_::size(offset)-binary, p::4-binary, _::binary>> = hmac

    # Return the last 31-bits
    <<_::1, truncation::31>> = p

    truncation
  end

  defp generate_hotp(truncated_hmac) do
    truncated_hmac
    |> rem(1000000)
    |> Integer.to_string
  end

  @doc """
  Generate Time-Based One-Time Password.
  The default period used to calculate the moving factor is 30s
  """
  def generate_totp(secret, period \\ 30) do
    secret
    |> generate_hmac(period)
    |> hmac_dynamic_truncation
    |> generate_hotp
  end

  @doc """
  Generate random_secret for TOTP, by default
  random_secret need 16 length of alphabet
  """
  def random_secret(length \\ 16) do
    alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    lists = String.split(alphabets <> String.downcase(alphabets), "", trim: true)

    do_randomizer(length, lists)
  end

  @doc false
  defp get_range(length) when length > 1, do: (1..length)
  defp get_range(length), do: [1]

  @doc false
  defp do_randomizer(length, lists) do
    get_range(length)
    |> Enum.reduce([], fn(_, acc) -> [Enum.random(lists) | acc] end)
    |> Enum.join("")
  end
end
