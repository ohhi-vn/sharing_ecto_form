defmodule DemoEctoForm.Candidate do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :bio, :string
  end

  def changeset(candidate, attrs \\ %{}) do
    candidate
    |> cast(attrs, [:name, :bio])
    |> validate_required([:name])
    |> update_change(:name, &String.trim/1)
    |> validate_format(:name, ~r/^[a-zA-Z\s]+$/)
    |> validate_format(:name, ~r/^\w+(?:\s+\w+){1,5}$/)
    |> validate_format(:bio, ~r/^\w+(?:\s+\w+){2,25}$/)
  end
end
