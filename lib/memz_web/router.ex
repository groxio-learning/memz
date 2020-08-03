defmodule MemzWeb.Router do
  use MemzWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MemzWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MemzWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/game/play", GameLive.Play, :play
    live "/game/over", GameLive.Play, :over
    live "/game/welcome", GameLive.Welcome, :welcome
    
    live "/readings", ReadingLive.Index, :index
    live "/readings/new", ReadingLive.Index, :new
    live "/readings/:id/edit", ReadingLive.Index, :edit

    live "/readings/:id", ReadingLive.Show, :show
    live "/readings/:id/show/edit", ReadingLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", MemzWeb do
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
      live_dashboard "/dashboard", metrics: MemzWeb.Telemetry
    end
  end
end
