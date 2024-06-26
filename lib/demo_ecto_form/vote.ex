defmodule DemoEctoForm.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  alias DemoEctoForm.{Ets}

  alias DemoEctoForm.Vote

 embedded_schema do
    field :name, :string, default: ""
    field :email, :string
    field :phone, :string
    field :vote_for, :string
    field :reason, :string
  end

  def changeset(vote, attrs \\ %{}) do
    vote
    |> cast(attrs, [:name, :email, :phone, :vote_for, :reason])
    |> validate_required([:name, :email, :vote_for])
    |> update_change(:name, &String.trim/1)
    |> update_change(:email, &String.trim/1)
    |> update_change(:phone, &String.trim/1)
    |> update_change(:vote_for, &String.trim/1)
    |> update_change(:reason, &String.trim/1)
    |> validate_length(:name, min: 5, max: 50)
    |> validate_length(:reason, min: 10)
    |> validate_length(:phone, min: 10, max: 15)
    |> validate_format(:name, ~r/^[a-zA-Z\s]+$/)
    |> validate_format(:name, ~r/^\w+(?:\s+\w+){1,3}$/)
    |> validate_format(:reason, ~r/^[a-zA-Z\s]+$/)
    |> validate_format(:reason, ~r/^\w+(?:\s+\w+){3,25}$/)
    |> validate_format(:email, ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/)
    |> validate_format(:phone, ~r/(?:([+]\d{1,4})[-.\s]?)?(?:[(](\d{1,3})[)][-.\s]?)?(\d{1,4})[-.\s]?(\d{1,4})[-.\s]?(\d{1,9})/)
    |> validate_inclusion(:vote_for, Ets.get_key_candidates())
  end

  def from_params!(params) do
    %Vote{}
    |> changeset(params)
    |> apply_action!(:update)
  end
end
