defmodule EthermassWeb.Router do
  use EthermassWeb, :router

  import EthermassWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {EthermassWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EthermassWeb do
    pipe_through :browser

  end

  # Other scopes may use custom stacks.
  # scope "/api", EthermassWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EthermassWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", EthermassWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", EthermassWeb do
    pipe_through [:browser, :require_authenticated_user]


    get "/", PageController, :index
    get "/addresses/:address/refresh_balance", AddressController, :refresh_eth_balance
    get "/addresses/generate", AddressController, :generate_form
    post "/addresses/generate", AddressController, :generate_post

    resources "/owner_list", OwnerListController
    resources "/market_maker", MarketMakerController

    get "/all_nft", PageController, :all_nft

    get "/addresses/batch_import", AddressController, :batch_import_form
    post "/addresses/batch_import", AddressController, :batch_import_post

    get "/address/update_nft_balance/:id", AddressController, :update_nft_balance
    get "/address/update_eth_balance/:id", AddressController, :update_eth_balance
    resources "/addresses", AddressController

    get "/transaction_batch/:id/toggle", TransactionBatchController, :toggle_start
    resources "/transaction_batch", TransactionBatchController

    get "/transaction_batch/mass_funding/new", TransactionBatchController, :new_mass_funding
    post "/transaction_batch/mass_funding", TransactionBatchController, :create_mass_funding
    get "/transaction_batch/mass_minting/new", TransactionBatchController, :new_mass_minting
    post "/transaction_batch/mass_minting", TransactionBatchController, :create_mass_minting
    get "/transaction_batch/mass_whitelist/new", TransactionBatchController, :new_mass_whitelist
    post "/transaction_batch/mass_whitelist", TransactionBatchController, :create_mass_whitelist

    get "/transaction_plan/:id/run", TransactionPlanController, :run_plan

    resources "/transaction_plans", TransactionPlanController

    resources "/smart_contracts", SmartContractController

    get "/test", PageController, :test
    get "/mass_funding_index", PageController, :mass_funding_index





    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", EthermassWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
