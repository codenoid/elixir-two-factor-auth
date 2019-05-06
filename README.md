# Elixir2fa

Library for generating QR-Code, Random Secret and Verify Time Based Password

## Installation

This package can be installed by adding `elixir2fa` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir2fa, "~> 0.1.0"}
  ]
end
```

## Usage

```
iex> secret = Elixir2fa.random_secret(16)     
"HpJBFRtHjgIQJWIB"
iex> Elixir2fa.generate_qr("account_name", secret)
"https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=200x200&chld=M|0&cht=qr&chl=otpauth://totp/account_name?secret=HpJBFRtHjgIQJWIB" # scan via Google Authenticator, Authy, etc
iex> Elixir2fa.generate_totp(secret)              
"573671" # compare with user token
```

Some source code taken from : 

* https://github.com/codenoid/elixir-two-factor-auth
* https://gist.github.com/ahmadshah/8d978bbc550128cca12dd917a09ddfb7
* https://github.com/SushiChain/crystal-two-factor-auth/blob/master/src/crystal-two-factor-auth.cr

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/elixir2fa](https://hexdocs.pm/elixir2fa).
