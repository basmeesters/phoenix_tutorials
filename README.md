Phoenix
=======

Introduction
------------

Standard breakdown of a HTTP request
```elixir
connection
  |> endpoint
  |> router       # directs a request to appropriate controller
  |> pipelines    # handle request, e.g. json or browser requests
  |> controller
```

controller breakdown
```elixir
connection
  |> controller
  |> common_services    # implemented with Plug (strategy to build web apps)
  |> action
```

Example action
```elixir
connection
  |> find_user
  |> view
  |> template
```

Databases in Phoenix: Ecto
* The model works on data & is pure
* The controller works with side effects and the outside world

Phoenix dependencies
* [x] Elixir & Erlang
* [x] Hex (package manager)
* [x] Node.js (not needed for just a JSON API, as it works on assets)
  - Also brunch.io to compile assets
  - NPM for JavaScript packages
  - inotify on Linux to allow live reloading
* [x] Ecto & PostgreSQL

Mix is used to execute tasks (elixir scripts)
* mix phoenix.new hello   # Create new phoenix project
* mix deps.get            # Get all dependencies
* mix ecto.create         # Create a new database for the project

Map requests coming in to a specific URL to the code that satifies that request:
* get "/hello", HelloController, :world  
  Send request with url /hello to world function in HelloController
* In this world function we point towards "world.html"
* Now we need a hello_view.ex to deal with that & a template world.html.eex

Routes and params:
* Use pattern matching in world function to deal with dynamic information
```elixir
  def world(conn, %{"name" => name}) do
    render conn, "world.html", name: name
  end
```

The request pipeline
* Basically, phoenix is a bunch of functions getting urls as input and returning
  formated html as strings
* Use Plug library to tie all the different functions together
* Each plug consumes and produces a Plug.Conn structure (Type: conn -> conn)

Project structure
-----------------
```
project
└─── config
└─── lib      # long living processes
└─── test
└─── web      # stuff that needs to be reloaded every time
```

Elixir configuration
* Phoenix projects are Elixir applications, they have the same structure as
  other Mix projects.
```
project
└─ lib
│   └─ hello
|   |  └─ endpoint.ex
|   |  └─ ...
|   └─ hello.ex
└─ mix.exs         # configuration
└─ mix.lock        # after compilation the specific verions we depend upon
└─ test    
```

Environments and endpoints
* Applications runs in an environment
  - Contains specific configuration that the app needs (config folder)
  - This folder contains files for each environment (dev, prod, etc.)
  - dev is default
  - Also contains 'master' config file for application wide config
  - Switch between env by setting MIZ_ENV
* endpoint.ex
  - Deal with typical web server stuff
  - Static content, log requests, parse parameters, etc.
  - Endpoint is a plug, made out of other plugs
  - Application is a series of plugs beginning with endpoint and ending with
    controller
  - Last plug in the endpoint is the router

Every Phoenix application looks like
```elixir
connection
|> endpoint      # Interface of your app, all requests come through here
|> router        # Match HTTP requests to controller actions
|> pipeline      # Common functions for each request
|> controller
```

Web
```
web
└─ channels
└─ controllers
│   └─ page_controller.ex
|   └─ hello_controller.ex
└─ models
└─ static
└─ templates
│   └─ hello
|   |  └─ world.html.eex
│   └─ layout
|   |  └─ app.html.eex
│   └─ page
|   |  └─ index.html.eex
└─ views
│   └─ error_view.ex
│   └─ layout_view.ex
│   └─ page_view.ex
│   └─ hello_view.ex
└─ router.ex                    # What to do with each request
└─ web.ex                       # Glue code to define whole app
```

What the application already does:
* Using Erlang and OTP engine it can already scale
* Endpoint filters static requests and cuts requests into pieces, trigger routes
* Browser pipeline will fetch sessions, protect CSRF attacks, etc.

Controllers, views and templates
--------------------------------
Pipeline (again)
* Request enters through endpoint
* Goes to the router which matches the URL pattern
* Request is dispatched through browser pipeline
* Comes in at controller

Databases
* Create a user in web/models by making a file user.ex
* defmodule with a defstruct
* iex -S mix to start Elixir Repl
* map: ` user = %{username: "Bas", surname: "meesters"}`
* struct: `user = %User(name: "Bas", surname: "meesters")`
* Use repository patterns to store users

Repositories
* First make a hardcoded implementation, later use Ecto
* Replace the Ecto stuff in repo.ex
* Make a hardcoded user with a struct
* Replace repo.ex with 'database' operations like get, all, etc.
* Use iex -S mix to verify results

Coding views
* Difference between views and templates
* After passing through the controlleBar the request is send to the view
* The view contains rendering functions to e.g. show HTML or JSON
* Templates are raw markup languages with embedded Elixir code
* code in <%= %> is elixir code that will be executed
* code between <% %> is evaluated but not injected (side effect)

Helpers
* Use standard HTML functions with helpers (such as link)
* Defined in web/web.ex
* More about helpers in Phoenix.HTML documentation
* Provide imports instead of changing web/web.ex

Naming
* Phoenix looks for UserView when in UserController & in templates/user for
  templates
* Use singular names

Re-use (nesting) templates
