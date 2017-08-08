defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Discuss.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Discuss do
    pipe_through :browser # Use the default browser stack

    #get "/", TopicController, :index
    #get "/topics/new", TopicController, :new
    #post "/topics", TopicController, :create
    #get "/topics/:id/edit", TopicController, :edit
    #put "/topics/:id", TopicController, :update

    #Use phoenix resources helper for rest api defined routes and controller functions
    resources "/", TopicController
  end

  scope "/auth", Discuss do
    pipe_through :browser # Use the default browser stack

    #route called when a users wants to sign out
    get "/signout", AuthController, :signout

    #route called when a user wants to authenticate with github
    get "/:provider", AuthController, :request
    #route called when a user is sent back from github to our application
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end

end
