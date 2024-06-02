defmodule DemoEctoFormWeb.Router do
  use DemoEctoFormWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DemoEctoFormWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DemoEctoFormWeb do
    pipe_through :browser

    live "/", VoteForm
    live "/result", VoteResult
    live "/candidate", CandidateForm
  end


  # Other scopes may use custom stacks.
  # scope "/api", DemoEctoFormWeb do
  #   pipe_through :api
  # end
end
