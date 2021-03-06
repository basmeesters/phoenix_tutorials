defmodule Rumbl.Repo do
  use Ecto.Repo, otp_app: :rumbl

  # EXAMPLE in-memory database
  @moduledoc """
  In memory repository

  Example usage:
    $ iex -S mix
    $ alias Rumble.User
    $ alias Rumble.Repo
    $ Repo.all User
    $ Repo.get User, "1"
  """
  # def all(Rumbl.User) do
  #   [%Rumbl.User{id: "1", name: "Bas Meesters", username: "bassie", password: "batty"},
  #    %Rumbl.User{id: "2", name: "Second Name", username: "second", password: "2"},
  #    %Rumbl.User{id: "3", name: "Third Name", username: "third", password: "2"}]
  # end
  #
  # def all(_module), do: []
  #
  # def get(module, id) do
  #   Enum.find all(module), fn map -> map.id == id end
  # end
  #
  # def get_by(module, params) do
  #   Enum.find all(module), fn map ->
  #     Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
  #   end
  # end
end
