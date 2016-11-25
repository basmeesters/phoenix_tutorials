defmodule Hello.HelloController do
  # Use Phoenix API functions by iuncluding Web
  use Hello.Web, :controller

  def world(conn, %{"name" => name}) do
    render conn, "world.html", name: name
  end
end
