defmodule Rumbl.User do
  # Example in-memory struct
  # defstruct [:id, :name, :username, :password]

  use Rumbl.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps
  end

  # Validate new user input
  def changeset(model, params\\ :empty) do
    model
    |> cast(params, ~w(name username), [])
    |> validate_length(:username, min: 3, max: 20)
  end

  # Validate and hash password on top of normal changeset
  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 30)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
