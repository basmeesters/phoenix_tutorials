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
* Use `render "user.html.eex"` to render a partial
* A template can be rendered in html attributes
  - e.g. `<td>render "x.html.eex"</td>`

Layouts
* When we call render in our controller, instead of rendering the desired view
  directly, the controller first renders the layout view, which then renders the
  actual template in a predefined markup. This allows developers to provide a
  consistent markup across all pages without duplicating it over and over again.
* See `web/templates/layout/app.html.eex`
* When you call render in your controller, you’re actually rendering with the
  :layout option set by default

Ecto & changesets
-----------------
Use Ecto as a persistent database. API is the same as used until now. Ecto
makes use of PostgreSQL.

Understanding Ecto
* Ecto is similar to Active Record.
* Ecto has _changesets_ that hold all cahnges you want to perform on the
  database.
* Ecto is 'turned on' in `lib/project-name.ex`
* Ecto is called in `lib/repo.ex`
* `lib/config/devs.ex` contains username / password etc.

Defining user schema and migration
* Ecto uses a DSL for creating database fields, see `web/models/`
* The 'model' is nothing more than a group of functions to transform data
  according to our business requirements.
* After having a Repo and User schema configured we need a migration.
* `mix​​ ​​ecto.gen.migration​​ ​​create_user​`
  - Creates a migration file with date.
  - In here the change should be 'version-ed'.
* Migrations help:
  - Make changes manageable.
  - Make rollbacks easier.
  - Easier to build a fresh development environment because history is explicit.
* `mix​​ ​​ecto.migrate​`
  - We now migrated in our development environment, set MIX_ENV to change this.
* `supervisor(Rumbl.Repo)` makes sure the process is controlled with OTP.
* You can still use Ecto API functions such as Repo.all(User) or
  Repo.get(User, 1).

Building forms
* Use phoenix form builders to allow creation of Users from the client
* Ecto.Changeset let Ecto manage record changes, cast parameters, and perform
  validations.
* Provide a changeset function in your model to validate input.
  - This is unconventional for persistence frameworks but avoids problems with
    the one size fit all approach.
  -
* resources in router is a shorthand implementation for a common set of actions
  that follow the REST convention.
  - Use the only keyword to e.g. do not allow delete operations.
  - Use `mix phoenix.routes` to see all available routes.
* Use changeset.action to catch errors on input in the client (see view).
* Ecto.changeset holds everyting related to a database change, including errors.
  - You can do valiations before entering information in a database.

Authenticating Users
--------------------
Preparing for authentication
* Use comeonin library for hashing
* application in mix.ex is a collection of modules that work together and can
  be managed as a whole.

Managing registration changesets
* Use a new, separate changeset for valiating passwords
  - This is slightly more work than conventional validation
  - Easier to separate requirements and management regarding changesets
