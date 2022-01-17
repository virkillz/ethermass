# Ethermass

Ethermass is a web application to perform mass transaction on Ethereum Network. Do you want to mass minting NFT? Do you want to organized thousands of addresses try to claim airdrop? 

Ethermass can be used for:
- Creating mass enthereum address (with public key, private key, and menumonic phrase)
- Organizing thousands of Ethereum Address (and private keys)
- Compose an ethereum transaction using Web GUI.
- Run Batch transaction using Web GUI. 
- Failure report on each transaction. 

Security Note on Private Key Management:
Private key and Menumonic is encrypted using symetric key and stored in database. The encryption key is stored as environtment variable. The security of the funds is as secured as how you can secure your server. My reccomnedation is to not deploy this remotely. Just use your local computer. 


Installation:
Ensure you have following installed:
- elixir ~> 1.12
- PostgreSQL ~> 13.0


To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
